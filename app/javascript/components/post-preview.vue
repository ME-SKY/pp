<template>
    <div class="prev">
        <div class="preview_image">
            <img :src="description_image">
        </div>
        <div class="preview_description">

        </div>
    </div>
</template>

<script>
    export default {
        props: ['description_image'],
        name: "post-preview",
    }
</script>

<style lang="scss" scoped>

    .prev{
        width: 520px;
        height: 380px;
    }

    .preview_image{
        display: flex;
        justify-content: center;

        img{
            max-width: 495px;
            max-height: 300px;
        }

    }

    .preview_description{

    }

</style>