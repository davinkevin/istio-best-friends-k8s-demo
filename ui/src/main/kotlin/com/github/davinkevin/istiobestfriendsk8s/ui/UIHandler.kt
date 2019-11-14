package com.github.davinkevin.istiobestfriendsk8s.ui

import org.springframework.context.annotation.Bean
import org.springframework.context.annotation.Configuration
import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.server.ServerRequest
import org.springframework.web.reactive.function.server.ServerResponse
import org.springframework.web.reactive.function.server.router
import java.time.ZonedDateTime.now

/**
 * Created by kevin on 2019-01-13
 */

@Configuration
class AppConfiguration {
    @Bean
    fun routes(UI: UIHandler) = router {
        GET("/", UI::serve)
    }
}

@Component
class UIHandler(val search: SearchService, prop: UIProperties) {

    val version = prop.version

    fun serve(serverRequest: ServerRequest) = search
            .search()
            .map { it.copy(from = "ui ($version) => ${it.from}", date = now() ) }
            .flatMap { ServerResponse.ok().bodyValue(it) }
}
