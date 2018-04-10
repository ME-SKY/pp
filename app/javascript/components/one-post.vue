<template>
    <article class="post-block" >
        <div class="post-wrapper">
            <header class="post-header">
                <h3 class="hmg"></h3>
                <!-- <img :src= "image_post_url" > -->
            </header>
            <section class="post">
                <div class="post-content">
                    <div id="htmled" v-html="content"></div>
                </div>
            </section>
            <section class="additional-post-info"></section>
            <footer class="post-footer"></footer>
        </div>
    </article>
</template>

<script>
    export default {
        props: ["content"]
//        computed: {
//            htmledPostContent: function(){
//                return this.content
//            }
//        }
    }
</script>

<style lang="scss" scoped >
    /*@import '../../../node_modules/trumbowyg/dist/ui/trumbowyg.min.css';*/
    @import '../styles/posts.scss';
</style>
