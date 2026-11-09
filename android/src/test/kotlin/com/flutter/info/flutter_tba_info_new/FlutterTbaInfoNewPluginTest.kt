package com.flutter.info.flutter_tba_info_new

import kotlin.test.Test
import kotlin.test.assertEquals

internal class FlutterTbaInfoNewPluginTest {
    @Test
    fun md5_returnsExpectedValue() {
        assertEquals("900150983cd24fb0d6963f7d28e17f72", md5("abc"))
    }
}
