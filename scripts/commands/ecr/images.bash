split_args "$@"

REPOSITORY_LISTING=$(awscli ecr describe-repositories --output text --query "sort_by(repositories,&repositoryName)[$(auto_filter repositoryName -- $FIRST_RESOURCE)].[repositoryName]")
select_one Repository "$REPOSITORY_LISTING"

FILTER=$(auto_filter imageDigest "(imageTags||[''])|join(',',@)" -- $SECOND_RESOURCE)

awscli ecr describe-images --repository-name $SELECTED --output table --query "imageDetails[$FILTER].{\"1.Digest\":imageDigest, \"2.Tags\":join(', ', sort(imageTags||[''])),\"3.ImageSize(Bytes)\":imageSizeInBytes}"
