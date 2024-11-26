output "bucket_arn" {
    value = aws_s3_bucket.tf_state_files.arn
}

output "bucket_id" {
    value = aws_s3_bucket.tf_state_files.id
}
