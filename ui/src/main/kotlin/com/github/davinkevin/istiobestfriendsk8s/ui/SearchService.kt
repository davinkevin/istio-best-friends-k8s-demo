package com.github.davinkevin.istiobestfriendsk8s.ui

import org.springframework.stereotype.Component
import org.springframework.web.reactive.function.client.WebClient
import org.springframework.web.reactive.function.client.bodyToMono

/**
 * Created by kevin on 2019-01-13
 */
@Component
class SearchService(wcb: WebClient.Builder, prop: UIProperties) {
    private val wc = wcb.baseUrl(prop.searchUrl)
            .build()

    fun search() = wc.get()
            .retrieve()
            .bodyToMono<DemoMessage>()
}
