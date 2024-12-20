
<!-- Example code for how to use this modules. -->
``` bash
module "apigw_sqs_integration" {
  source     = "../../modules/api-gateway"
  name                 = "${var.name}-${var.environment}-sqs-api-gw"
  environment          = var.environment
  enable_custom_domain = false
  region               = var.region
   integrations = [
    {
      sqs_url     = module.sqs_queue_btc.sqs_url  
      sqs_arn     = module.sqs_queue_btc.sqs_arn
      route_key   = "POST /btc"
      description = "Integration for BTC SQS queue"
    },
    {
      sqs_url     = module.sqs_queue_eth.sqs_url
      sqs_arn     = module.sqs_queue_eth.sqs_arn
      route_key   = "POST /eth"
      description = "Integration for ETH SQS queue"
    }, 
    {
      sqs_url     = module.sqs_queue_solana.sqs_url
      sqs_arn     = module.sqs_queue_solana.sqs_arn
      route_key   = "POST /solana"
      description = "Integration for Solana SQS queue"
    }
  ]
}
```