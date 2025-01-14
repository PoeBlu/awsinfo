split_args "$@"

USERS=$(awscli iam list-users --output text --query "Users[$(auto_filter UserName UserId Path -- $FIRST_RESOURCE )].[UserName]")
select_one Role "$USERS"

USER=$SELECTED

USERS=$(awscli iam list-user-policies --user-name $USER --output text --query "PolicyNames[$(filter @ $SECOND_RESOURCE)].[@]")
select_one Policy "$USERS"

awscli iam get-user-policy --user-name $USER --policy-name $SELECTED --output table --query "@.{
  \"PolicyStatement\":PolicyDocument.Statement[].{
    \"1.Effect\": Effect,
    \"2.Action\": [Action][],
    \"3.Resource\": [Resource][]}}"
