<template>
    <div id = 'app_posts' >
        <div class="editor" >
            <div v-on:click="show = !show" >
                <font-awesome-icon :icon="faPlusSquire" size="3x"></font-awesome-icon>
            </div>
            <transition name="fade">
                <div v-if="show" >
                    <div id="editor-box">
                        <rich-text-editor/>
                    </div>
                </div>
            </transition>
        </div>
        <div class="posts_list_component"><posts-list/></div>
        <!--<div class="enother_component2">qergwergwrgewgrwergwergwergwrgewg</div>-->
    </div>
</template>

<script>
    import PostsList from './components/posts-list.vue'
    import RichTextEditor from './components/rich-text-editor.vue'
    import FaPlusSquare from '@fortawesome/fontawesome-free-solid/faPlusSquare'
//    import { MdButton, MdContent, MdTabs } from 'vue-material/dist/components'
//    import 'bootstrap/dist/css/bootstrap.css'
//    import 'bootstrap-vue/dist/bootstrap-vue.css'
//    import 'vue-material/dist/vue-material.css'
//    import 'vue-material/dist/vue-material.min.css'

    export default {
        data: function(){
            return {show: false}

        },
        methods: {
           openAndCloseEditor: function(){
                this.show = !this.show
           }
        },
        components: {
            PostsList, RichTextEditor
        },
        computed: {
            faPlusSquire () {
                return FaPlusSquare
            }
        }
    }
</script>

<style lang="scss"  >
    /*@include 'styles/uikitLoad';*/
    /*@import '../../../node_modules/trumbowyg/dist/ui/trumbowyg.min.css';*/

    #app_posts{
        display: flex;
        flex-direction: column;
        /*justify-content: space-between;*/
    }

    #editor{

    }
    /*#editor-box{*/
        /*max-height: 0;*/
        /*transition: max-height 3s ease-out;*/
    /*}*/
    /*.enother_component1{*/
        /*width: 300px;*/
    /*}*/

    .fade-enter-active, .fade-leave-active {
        transition:  .5s ease;
        /*max-height: 700px;*/
    }
    .fade-enter-to, .fade-leave{
        max-height: 700px;
    }
    /*.fade-leave-active {*/
        /*transition:  5s;*/
        /*max-height: 700px;*/
    /*}*/
    .fade-enter, .fade-leave-to
        /* .slide-fade-leave-active до версии 2.1.8 */ {
        /*transform: translateY(-500px) ;*/
        /*transition:  height 3s;*/
        opacity: 0;
        max-height:  0px;
    }


    /*.fade-enter{*/
        /*height: 0px;*/
        /*transition: height 3s;*/
    /*}*/
    /*.fade-enter-active{*/
        /*height: 150px;*/
        /*transition: height 2s;*/

    /*}*/
    /*.fade-enter-to{*/
        /*!*transition: height .5s;*!*/
        /*height: auto;*/
    /*}*/
    /*!*.fade-leave{*!*/
        /*!*transition: height .5s;*!*/
/*!**!*/
    /*!*}*!*/
    /*.fade-leave-active{*/
        /*transition: height 2s ease-out 4s;*/

    /*}*/
    /*.fade-leave-to{*/
        /*transition: height .5s;*/
    /*}*/

    /*.fade-enter-active, .fade-leave-active {*/
        /*!*transition-property: height;*!*/

        /*transition: opacity 3s, height 3s;*/
    /*}*/
    /*.fade-enter, .fade-leave-to !* .fade-leave-active до версии 2.1.8 *! {*/
        /*opacity: 0;*/
        /*!*height: px;*!*/
        /*transition: opacity 3s, height 3s;*/

    /*}*/
</style>