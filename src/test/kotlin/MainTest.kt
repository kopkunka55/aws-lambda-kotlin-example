import com.amazonaws.services.lambda.runtime.Context
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent
import io.mockk.mockk
import org.junit.jupiter.api.Assertions.*
import org.junit.jupiter.api.Test

internal class MainTest {
    val context = mockk<Context>()

    @Test
    fun `Success Pattern`(){
        val event = DynamodbEvent()
        val main = Main()
        val result = main.handleRequest(event, context)
        println(result)
    }

    @Test
    fun `Failure Pattern`(){
        val event = null
        val main = Main()
        val result = main.handleRequest(event, context)
        assert(result == "Error")
    }
}