package com.github.davinkevin.istiobestfriendsk8s.search

import org.springframework.boot.autoconfigure.SpringBootApplication
import org.springframework.boot.runApplication
import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.server.ServerRequest
import org.springframework.web.reactive.function.server.ServerResponse.ok
import org.springframework.web.reactive.function.server.router

@SpringBootApplication
class SearchApplication

fun main(args: Array<String>) {
    runApplication<SearchApplication>(*args)
}

@Configuration
class AppConfiguration {
    @Bean
    fun routes(search: SearchHandler) = router {
        GET("/", search::serve)
    }
}

@Component
class SearchHandler(prop: SearchProperties) {

    val version = prop.version

    fun serve(serverRequest: ServerRequest) = ok()
            .syncBody(DemoMessage("Touraine Tech' 2019", "search ($version)"))
}

data class DemoMessage(val hello: String, val from: String)

