package com.github.davinkevin.istiobestfriendsk8s.search

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.stereotype.Component

/**
 * Created by kevin on 2019-01-13
 */
@Component
@ConfigurationProperties("search")
class SearchProperties {
    lateinit var version: String
    lateinit var event: String
}
