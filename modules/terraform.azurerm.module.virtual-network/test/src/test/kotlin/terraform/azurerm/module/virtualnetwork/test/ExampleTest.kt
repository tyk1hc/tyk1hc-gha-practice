package terraform.azurerm.module.virtualnetwork.test

import com.jayway.jsonpath.matchers.JsonPathMatchers
import org.hamcrest.MatcherAssert
import org.hamcrest.Matchers
import org.junit.jupiter.api.AfterAll
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import terraform.test.common.*
import java.io.File

class ExampleTest {

    companion object {

        private val fixtureDir = File("../example")
        private val releaseVersionFile = File("../RELEASE")
        private val rg_name = nonce()
        private val vnet_name = "$rg_name-vnet"

        val vars = mapOf(
                "rg_name" to rg_name,
                "vnet_name" to vnet_name
        )

        var res: Map<String, Any?>? = null

        @JvmStatic
        @BeforeAll
        fun before() {
            fixtureDir.tfInit()
            fixtureDir.tfApply(vars)
            res = resource(Resource.virtualNetworks, vnet_name, rg_name)
        }

        @JvmStatic
        @AfterAll
        fun after() {
            fixtureDir.tfDestroy(vars)
        }
    }

    @Test
    fun `Verify that provisioning is successful`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.properties.provisioningState",
                Matchers.equalToIgnoringCase("succeeded")))
    }

    @Test
    fun `Verify that module version tag is set`() {
        MatcherAssert.assertThat(res, JsonPathMatchers.hasJsonPath("$.tags.module_version", Matchers.equalToIgnoringCase(releaseVersionFile.readText())))
    }

}