<template>
    <div id = 'app_posts' >
        <div class="enother_component1" >
            <div v-on:click="show = !show" >
                <button>I am a Button</button>
            </div>
            Здесь будет красивая кнопочка для вызова формы с редактором для создания нового поста.
            <transition name="fade"> <div v-if="show" >блаблабла</div> </transition>
        </div>
        <div class="posts_list_component"><posts-list/></div>
        <div class="enother_component2">qergwergwrgewgrwergwergwergwrgewg</div>
    </div>
</template>

<script>
    import PostsList from './components/PostsList.vue'
//    import { MdButton, MdContent, MdTabs } from 'vue-material/dist/components'
//    import 'bootstrap/dist/css/bootstrap.css'
//    import 'bootstrap-vue/dist/bootstrap-vue.css'
//    import 'vue-material/dist/vue-material.css'
//    import 'vue-material/dist/vue-material.min.css'

    export default {
        data: function(){
            return {show: true}

        },
        methods: {
           openAndCloseEditor: function(){
                this.show = !this.show
           }
        },
        components: {
            'posts-list': PostsList
        }
    }
</script>

<style lang="scss"  >
    /*@include 'styles/uikitLoad';*/
    /*@import '../../../node_modules/trumbowyg/dist/ui/trumbowyg.min.css';*/

    #app_posts{
        display: flex;
        justify-content: space-between;
    }
    .enother_component1{
        width: 300px;
    }
    .fade-enter-active, .fade-leave-active {
        transition: opacity .5s;
    }
    .fade-enter, .fade-leave-to /* .fade-leave-active до версии 2.1.8 */ {
        opacity: 0;
    }
</style>