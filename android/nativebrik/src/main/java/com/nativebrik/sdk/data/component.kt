package com.nativebrik.sdk.data

import com.nativebrik.sdk.Config
import com.nativebrik.sdk.schema.UIBlock
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext
import kotlinx.serialization.json.Json
import kotlinx.serialization.json.JsonElement

interface ComponentRepository {
    suspend fun fetchComponent(experimentId: String, id: String): Result<UIBlock>
}

class ComponentRepositoryImpl(private val config: Config): ComponentRepository {
    override suspend fun fetchComponent(experimentId: String, id: String): Result<UIBlock> {
        return withContext(Dispatchers.IO) {
            val url = config.endpoint.cdn + "/projects/" + config.projectId + "/experiments/components/" + experimentId + "/" + id
            val response: String = getRequest(url).getOrElse {
                return@withContext Result.failure(it)
            }
            val json = Json.decodeFromString<JsonElement>(response)
            val configs = UIBlock.decode(json) ?: return@withContext Result.failure(FailedToDecodeException())
            return@withContext Result.success(configs)
        }
    }
}
