<template>
    <div class="postslistclass">
        <!--<quill-editor/>-->
        <editor-aga/>
        <editor-ck/>
        <rich-editor/>
        <div v-for="post in all_posts" class="one_post">
            <one-post-comp :image_post_url="post_header_image_url(post)"
                           :theme="post.theme"
                           :description="post.description"/>
        </div>
    </div>
</template>

<script>
//  import Trumbo from '../../../node_modules/trumbowyg/dist/trumbowyg.min.js';
//  $('#trumbo_editor').trumbowyg();
//  alert($('#trumbo_editor').length)
//  import trumbowyg from 'vue-trumbowyg'
//  import 'trumbowyg/dist/ui/trumbowyg.css'
  import OnePost from './one_post'
  import EditorAga from './editor_aga'
import EditorCk from './editor_ck'
import RichTextEditor from './rich_text_editor'
//import { quillEditor } from 'vue-quill-editor'
//import 'quill/dist/quill.core.css'
//import themeShow from  'quill/dist/quill.snow.css'
//import 'quill/dist/quill.bubble.css'
//import { Snow } from 'quill/dist/quill.snow.css'
//quillEditor.register({
//    'modules/toolbar': Toolbar,
//    'themes/snow': Snow
//    'formats/bold': Bold,
//    'formats/italic': Italic,
//    'formats/header': Header
//})

//VueQuillEditor.register({theme: themeShow})
//import OnePost from 'OnePost.vue

export default {
  components: {
    'one-post-comp': OnePost,
    'editor-aga': EditorAga,
    'editor-ck': EditorCk,
      'rich-editor': RichTextEditor
//    'quill-editor-vue': quillEditor({'themes/show': Show})
  },
  data: function(){
    return {
//        content: '<h2 class="ql-align-center"><span class="ql-font-serif">Text content loading..</span></h2>',
//        editorOption: {
//            modules: {
//                toolbar: [
//                    ['bold', 'italic', 'underline', 'strike'],
//                    ['blockquote', 'code-block'],
//                    [{ 'header': 1 }, { 'header': 2 }],
//                    [{ 'list': 'ordered' }, { 'list': 'bullet' }],
//                    [{ 'script': 'sub' }, { 'script': 'super' }],
//                    [{ 'indent': '-1' }, { 'indent': '+1' }],
//                    [{ 'direction': 'rtl' }],
//                    [{ 'size': ['small', false, 'large', 'huge'] }],
//                    [{ 'header': [1, 2, 3, 4, 5, 6, false] }],
//                    [{ 'font': [] }],
//                    [{ 'color': [] }, { 'background': [] }],
//                    [{ 'align': [] }],
//                    ['clean'],
//                    ['link', 'image', 'video']
//                ]}},
        all_posts: []
    }
  },
  methods: {
   post_header_image_url: function(postik) {
//     console.log(postik)
     if(postik.attachments.length != 0){
//       console.log(postik);
       return postik['attachments']['0']['file']['url'];
     }
   },
//   post_info: function(post){
//     return post
//   },
   get_posts: function(){
     this.$http.get('/posts').then(function(responce) {
//       console.log(responce)
       this.all_posts = responce.body
//       return responce[]
//       return { responce_body: responce.body }
     }, function(error){
       // error
     })
   }
 },
 created: function() {
   this.get_posts()
 }
}

</script>

<style lang="scss" scoped >
    /*@import '../../../node_modules/trumbowyg/dist/ui/trumbowyg.min.css';*/
/*.one_post{*/
  /*width: 30px;*/
  /*height: 20px;*/
/*}*/
/*.title {*/
  /*font: 1em "Source Code Pro", Monaco, monospace;*/
  /*color: #de5c35;*/
  /*text-align: center;*/
/*}*/

/*article{*/
  /*margin-bottom: 30px;*/
  /*position: relative;*/
  /*display: flex;*/
  /*flex-direction: row;*/
  /*justify-content: center;*/
/*}*/


/*.post-header{*/
    /*img {*/
      /*width: 400px;*/
      /*max-width: 300px !important;*/
    /*}*/
/*}*/

/*.post{*/
  /*p{*/
    /*font-family: "Helvetica Neue",HelveticaNeue,Arial,sans-serif;*/
  /*}*/

  /*margin: 5px;*/
  /*padding: 10px;*/
  /*display: block;*/
  /*overflow-wrap: normal;*/
  /*word-wrap: normal;*/
  /*word-break: break-all;*/
  /*box-sizing: content-box;*/

  /*.post_text{*/
    /*font-family: "Helvetica Neue",HelveticaNeue,Arial,sans-serif !important;*/
    /*text-align: justify;*/
  /*}*/
/*.post-wrapper{*/
  /*background: #fff;*/
  /*border-radius: 6px;*/
  /*overflow: hidden;*/
  /*padding: 0;*/
  /*position: relative;*/
  /*background-clip: padding-box;*/
  /*border: 1px solid #eee;*/


/*}*/
/*}*/

</style>
