<template>
    <div id = 'app_posts' >
        <div class="editor" >
            <div v-on:click="show = !show"  id="open-create-new-post">
                <font-awesome-icon :icon="faPlusSquire" size="3x"></font-awesome-icon>
            </div>
            <transition name="fade">
                <div v-if="show" id="editor-box">
                    <rich-text-editor/>
                </div>
            </transition>
            <div id="hidden-empty-tag"></div>
        </div>
        <div class="posts_list_component"><posts-list/></div>
    </div>
</template>

<script>
    import PostsList from './components/posts-list.vue'
    import RichTextEditor from './components/rich-text-editor.vue'
    import FaPlusSquare from '@fortawesome/fontawesome-free-solid/faPlusSquare'

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

    #app_posts{
        display: flex;
        flex-direction: column;
    }

    .editor{
        display: flex;
        flex-direction: row;
        justify-content: space-between;
    }

    #editor-box{
        margin-left: 35%;
        margin-right: auto;
    }

    #hidden-empty-tag{
        opacity: 0;
    }

    .fade-enter-active, .fade-leave-active {
        transition:  .4s ease;
    }
    .fade-enter-to, .fade-leave{
        max-height: 700px;
    }
    .fade-enter, .fade-leave-to {
        opacity: 0;
        max-height:  0px;
    }
</style>
