<template>
    <article class="post-block">
    <div class="post-wrapper">
        <header class="post-header">
            <img :src="post.header_img">
        </header>
        <section class="post">
            <div class="post-content">
                <h3 class="title">{{ post.title }}</h3>
                <p class="border post_text"> {{ post.text }}</p>
            </div>
        </section>
        <section class="additional-post-info"></section>
        <footer class="post-footer"></footer>
    </div>

</template>

<script>
    export default {
        props: ["original_posts"]
    }
</script>

<style scoped>
    p {
        font-size: 2em;
        text-align: center;
    }
</style>