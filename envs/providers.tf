provider "aws" {
  default_tags {
    tags = {
      project = "sushi-order-system"
    }
  }
  region = "ap-northeast-1"
}
