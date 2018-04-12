while getopts "d:" opt; do
    case "$opt" in
        d) MAX_DURATION="--duration-seconds $(expr $OPTARG \* 3600)" ;;
    esac
done
shift $(($OPTIND-1))

split_args "$@"

ORGANIZATIONS=$(awscli organizations list-accounts --output text --query "Accounts[$(auto_filter Name Id Status Email -- $FIRST_RESOURCE)].[Id]")
select_one Organization "$ORGANIZATIONS"

ROLE="$SECOND_RESOURCE"

if [[ ! $ROLE ]]
then
  ROLE="OrganizationAccountAccessRole"
fi

awscli sts assume-role --role-arn arn:aws:iam::$SELECTED:role/$ROLE ${MAX_DURATION:-} --role-session-name $SELECTED-$ROLE-$RANDOM --output json | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=" + .AccessKeyId + " AWS_SECRET_ACCESS_KEY=" + .SecretAccessKey + " AWS_SESSION_TOKEN=\"" + .SessionToken + "\" AWS_TOKEN_EXPIRATION=" + .Expiration'
