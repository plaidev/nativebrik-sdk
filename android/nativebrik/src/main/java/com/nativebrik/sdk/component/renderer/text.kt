package com.nativebrik.sdk.component.renderer

import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.text.BasicText
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.layout.ContentScale
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.TextStyle
import androidx.compose.ui.unit.sp
import androidx.compose.ui.zIndex
import coil.compose.AsyncImage
import coil.compose.rememberAsyncImagePainter
import coil.request.ImageRequest
import com.nativebrik.sdk.component.provider.data.DataContext
import com.nativebrik.sdk.component.provider.event.eventDispatcher
import com.nativebrik.sdk.component.provider.event.skeleton
import com.nativebrik.sdk.schema.Color
import com.nativebrik.sdk.schema.FontDesign
import com.nativebrik.sdk.schema.FontWeight
import com.nativebrik.sdk.schema.TextAlign
import com.nativebrik.sdk.schema.UITextBlock
import com.nativebrik.sdk.template.compile
import com.nativebrik.sdk.template.hasPlaceholder
import com.nativebrik.sdk.vendor.blurhash.BlurHashDecoder
import androidx.compose.ui.graphics.Color as PrimitiveColor
import androidx.compose.ui.text.font.FontFamily as PrimitiveFontFamily
import androidx.compose.ui.text.font.FontWeight as PrimitiveFontWeight
import androidx.compose.ui.text.style.TextAlign as PrimitiveTextAlign

internal fun parseFontDesign(fontDesign: FontDesign?): PrimitiveFontFamily {
    return when (fontDesign) {
        FontDesign.DEFAULT -> PrimitiveFontFamily.Default
        FontDesign.ROUNDED -> PrimitiveFontFamily.Cursive
        FontDesign.MONOSPACE -> PrimitiveFontFamily.Monospace
        FontDesign.SERIF -> PrimitiveFontFamily.Serif
        else -> PrimitiveFontFamily.Default
    }
}

internal fun parseFontWeight(fontWeight: FontWeight?): PrimitiveFontWeight {
    return when (fontWeight) {
        FontWeight.ULTRA_LIGHT -> PrimitiveFontWeight.ExtraLight
        FontWeight.THIN -> PrimitiveFontWeight.Thin
        FontWeight.LIGHT -> PrimitiveFontWeight.Light
        FontWeight.REGULAR -> PrimitiveFontWeight.Normal
        FontWeight.MEDIUM -> PrimitiveFontWeight.Medium
        FontWeight.SEMI_BOLD -> PrimitiveFontWeight.SemiBold
        FontWeight.BOLD -> PrimitiveFontWeight.Bold
        FontWeight.HEAVY -> PrimitiveFontWeight.ExtraBold
        FontWeight.BLACK -> PrimitiveFontWeight.Black
        else -> PrimitiveFontWeight.Normal
    }
}

internal fun parseFontStyle(size: Int? = null, color: Color? = null, fontWeight: FontWeight? = null, fontDesign: FontDesign? = null, alignment: TextAlign? = null, transparent: Boolean = false): TextStyle {
    val textColor = parseColorForText(color) ?: PrimitiveColor.Black // get from theme
    return TextStyle.Default.copy(
        color = if (transparent) PrimitiveColor.Transparent else textColor,
        fontSize = size?.sp ?: 16.sp,
        fontWeight = parseFontWeight(fontWeight = fontWeight),
        fontFamily = parseFontDesign(fontDesign = fontDesign),
        textAlign = parseTextAlign(alignment = alignment),
    )
}

internal fun parseTextAlign(alignment: TextAlign?): PrimitiveTextAlign {
    return when (alignment) {
        TextAlign.CENTER -> PrimitiveTextAlign.Center
        TextAlign.LEFT -> PrimitiveTextAlign.Left
        TextAlign.RIGHT -> PrimitiveTextAlign.Right
        else -> PrimitiveTextAlign.Unspecified
    }
}

@Composable
internal fun Text(block: UITextBlock, modifier: Modifier = Modifier) {
    val data = DataContext.state
    val loading = data.loading
    var value = block.data?.value ?: ""
    var skeleton = false
    if (hasPlaceholder(block.data?.value ?: "")) {
        skeleton = loading
        value = if (loading) block.data?.value ?: "" else compile(block.data?.value ?: "", data.data)
    }
    val containerModifier = modifier
        .eventDispatcher(block.data?.onClick)
        .styleByFrame(block.data?.frame)
        .skeleton(skeleton)

    val fontStyle = parseFontStyle(
        size = block.data?.size,
        color = block.data?.color,
        fontWeight = block.data?.weight,
        fontDesign = block.data?.design,
        alignment = null,
        transparent = skeleton,
    )
    var maxLines = block.data?.maxLines ?: Int.MAX_VALUE
    if (maxLines <= 0) {
        maxLines = Int.MAX_VALUE
    }

    Box(modifier = containerModifier) {
        if (block.data?.frame?.backgroundSrc != null) {
            val src = compile(block.data.frame.backgroundSrc, data.data)
            val fallback = parseImageFallbackToBlurhash(src)
            val decoded = BlurHashDecoder.decode(
                blurHash = fallback.blurhash,
                height = fallback.height,
                width = fallback.width
            )
            AsyncImage(
                modifier = Modifier
                    .zIndex(0f)
                    .matchParentSize(),
                model = ImageRequest.Builder(LocalContext.current)
                    .data(src)
                    .crossfade(true)
                    .build(),
                contentDescription = null,
                contentScale = ContentScale.Crop,
                placeholder = rememberAsyncImagePainter(decoded),
            )
        }
        BasicText(
            text = value,
            modifier = Modifier.zIndex(1f),
            style = fontStyle,
            maxLines = maxLines,
        )
    }
}