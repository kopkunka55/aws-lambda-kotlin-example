import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.RequestHandler
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent
import mu.KotlinLogging

class Main : RequestHandler<DynamodbEvent, String>{
    private val logger = KotlinLogging.logger {}

    override fun handleRequest(input: DynamodbEvent?, context: Context?): String {
        val response = "200 OK"
        if (input != null) {
            input.records?.let {
                for (record in it){
                    logger.info { record.eventID }
                    logger.info { record.eventName }
                    logger.info { record.dynamodb.toString() }
                }
            }
            logger.info { "Successfully executed!"}
            return response
        } else {
            logger.warn { "Error: DynamoDB record is null" }
            return "Error"
        }
    }
}
