awscli acm list-certificates --output table --query "CertificateSummaryList[$(filter DomainName $@)].{\"1.Domain\":DomainName,\"2.Arn\":CertificateArn}"