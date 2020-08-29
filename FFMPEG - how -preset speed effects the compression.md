FFMPEG - how -preset <speed> effects the compression

https://github.com/FFmpeg/FFmpeg/blob/master/libavcodec/qsvenc.h#L82-L88

```c
{ "veryfast",    NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_BEST_SPEED  },   INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "faster",      NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_6  },            INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "fast",        NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_5  },            INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "medium",      NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_BALANCED  },     INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "slow",        NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_3  },            INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "slower",      NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_2  },            INT_MIN, INT_MAX, VE, "preset" },                                                \
{ "veryslow",    NULL, 0, AV_OPT_TYPE_CONST, { .i64 = MFX_TARGETUSAGE_BEST_QUALITY  }, INT_MIN, INT_MAX, VE, "preset" },                                                \
```

https://github.com/FFmpeg/FFmpeg/blob/master/libavcodec/qsvenc.c#L504-L511

```c
} else if (avctx->compression_level >= 0) {
    if (avctx->compression_level > MFX_TARGETUSAGE_BEST_SPEED) {
        av_log(avctx, AV_LOG_WARNING, "Invalid compression level: "
                "valid range is 0-%d, using %d instead\n",
                MFX_TARGETUSAGE_BEST_SPEED, MFX_TARGETUSAGE_BEST_SPEED);
        avctx->compression_level = MFX_TARGETUSAGE_BEST_SPEED;
    }
}
```