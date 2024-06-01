package terraform.azurerm.module.storageaccount.test

import com.jayway.jsonpath.matchers.JsonPathMatchers.hasJsonPath
import org.hamcrest.MatcherAssert.assertThat
import org.hamcrest.Matchers.containsString
import org.hamcrest.Matchers.equalToIgnoringCase
import org.junit.jupiter.api.AfterAll
import org.junit.jupiter.api.BeforeAll
import org.junit.jupiter.api.Test
import terraform.test.common.*
import java.io.File

class ExampleTest {

    companion object {

        private val fixtureDir = File("../example")
        private val releaseVersionFile = File("../RELEASE")

        private val vars = mapOf(
            "name" to nonce()
        )

        var res: Map<String, Any?>? = null

        @JvmStatic
        @BeforeAll
        fun before() {
            fixtureDir.tfInit()
            fixtureDir.tfApply(vars)
            res = resource(Resource.storageAccounts, vars.getValue("name"), vars.getValue("name") + "-example-storageaccount-rg")
        }

        @JvmStatic
        @AfterAll
        fun after() {
            fixtureDir.tfDestroy(vars)
        }
    }

    @Test
    fun `Verify that provisioning is successful`() {
        assertThat(res, hasJsonPath("$.properties.provisioningState",
                equalToIgnoringCase("succeeded")))
    }

    @Test
    fun `Verify that module version tag is set`() {
        assertThat(res, hasJsonPath("$.tags.module_version", equalToIgnoringCase(releaseVersionFile.readText())))
    }

    @Test
    fun `Verify the SKU name`() {
        assertThat(res, hasJsonPath("$.sku.name", containsString("Standard_LRS")))
    }

    @Test
    fun `Verify the SKU tier`() {
        assertThat(res, hasJsonPath("$.sku.name", containsString("Standard")))
    }

    @Test
    fun `Verify the location of the storage account`() {
        assertThat(res, hasJsonPath("$.location", equalToIgnoringCase("westeurope")))
    }

    @Test
    fun `Verify provisioningState`() {
        assertThat(res, hasJsonPath("$.properties.provisioningState", equalToIgnoringCase("succeeded")))
    }
}