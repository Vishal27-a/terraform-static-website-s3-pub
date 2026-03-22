# S3 Bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
}

# Enable Website Hosting
resource "aws_s3_bucket_website_configuration" "website_config" {
  bucket = aws_s3_bucket.my_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# Upload HTML file
resource "aws_s3_object" "index" {
  bucket       = aws_s3_bucket.my_bucket.bucket
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}

# Disable Public Access Block
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket = aws_s3_bucket.my_bucket.id

  block_public_acls   = false
  block_public_policy = false
}

# Bucket Policy (Public Access)
resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.my_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Sid       = "PublicReadGetObject"
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.my_bucket.arn}/*"
    }]
  })
}