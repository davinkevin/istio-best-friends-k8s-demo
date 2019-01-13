package com.github.davinkevin.istiobestfriendsk8s.ui

import org.springframework.boot.context.properties.ConfigurationProperties
import org.springframework.stereotype.Component

/**
 * Created by kevin on 2019-01-13
 */
@Component
@ConfigurationProperties("ui")
class UIProperties {
    lateinit var version: String
    lateinit var searchUrl: String
}