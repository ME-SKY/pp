<template>
    <div class="editable_content">
        <div class="edit-buttons">
            <div class="edit-buttons-group">
                <button class="edit-button" @click="execCmd('bold')" :class="{ style_active: buttons_activity.b_active}">
                    <font-awesome-icon :icon="iconBold" class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button" @click="execCmd('italic')" :class="{ style_active: buttons_activity.i_active}">
                    <font-awesome-icon :icon="iconItalic"  class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button" id="imageEditButton" @click="clickInputField" >
                    <font-awesome-icon :icon="iconImage" class="iconBox"></font-awesome-icon>
                </button>
            </div>
            <div class="not-a-buttons-group">
            </div>
        </div>

        <form action="/attachments/" method="post" contenteditable="false" enctype="multipart/form-data" name="attachment">
            <input @change="imgUploadAndInsert"  type="file" name="file" accept="image/*"  hidden/>
        </form>

        <div id="richED" contenteditable="true" @mouseup="seeStyleOnTools" >

        </div>

        <!--<iframe name="richEditor" id="richEditor" class="rich_editor" contenteditable="true" style="overflow-x:hidden;" >-->
        <!--</iframe>-->

        <div class="saveAndPublic">
            <div class="saveContentAsPost" @click="saveAsPost">
                 <font-awesome-icon :icon="saveContent"></font-awesome-icon>
            </div>
        </div>

        <!--<div id="richEditorDiv">-->
        <!--</div>-->
    </div>
</template>

<script>
    import faImage from '@fortawesome/fontawesome-free-solid/faImage'
    import faSave from '@fortawesome/fontawesome-free-solid/faSave'
    import faBold from '@fortawesome/fontawesome-free-solid/faBold'
    import faItalic from '@fortawesome/fontawesome-free-solid/faItalic'

    var RichED = document.querySelector('div[id="richED"]')

    var tag_names = ['b', 'i']


    export default {
        data: function(){
          return {
              buttons_activity: {
                  b_active: false,
                  i_active: false
              },

          }
        },
        computed: {
            iconImage () {return faImage},
            iconBold () {return faBold},
            iconItalic () {return faItalic},
            saveContent () {return faSave}

        },
        // mounted: function(){
            // this.$nextTick(function () {
            //     richEditor.document.open();
            //     richEditor.document.close();
            //     richEditor.document.designMode = 'on'
            //     richEditor.focus()

            // var vc = this
            // vc.$on('blur', this.returnFocusBack())
            // if (document.querySelector('#editor-box')){
            //     console.log('document activated?: ' + vc.activated)
                // richEditor.focus()

            // })
        // },
        // activated: function() {
        //   console.log('activated')
          // richEditor.document.open()
          // richEditor.document.close()
          // var eMouseOver = new Event('mouseover')
          // var eClick = new Event('click')
          // richEditor.dispatchEvent(eMouseOver)
          // richEditor.dispatchEvent(eClick)
          // console.log('richEditor.document.designMode: ' + richEditor.document.designMode )
          // console.log('richEditor.document.hasFocus: ' + richEditor.document.hasFocus())
          // richEditor.document.designMode = 'on'
          // richEditor.document
          // richEditor.focus()
        // },
        methods: {
            saveAsPost: function(){
                var content = RichED.innerHTML
                // var content = richEditor.document.body.innerHTML
                var formData = new FormData()
                var xhr = new XMLHttpRequest()
                // var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                var vc = this

                xhr.open("POST", "/posts/")
                xhr.setRequestHeader('X-CSRF-Token', this.tokenCSRF())

                formData.append("content", content)
                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        // var postId = respText.id
                        vc.$root.$emit('newPostIsCreated', respText)
                    }
                }
            },
            clickInputField: function() {
                document.querySelector('input[name="file"]').click()
            },
            imgUploadAndInsert: function (e) {
                var vc = this
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()
                // var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', this.tokenCSRF())

                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        var fileUrl = respText.file.url
                        document.execCommand('insertImage', false, fileUrl)

                        // richEditor.document.execCommand('insertImage', false, fileUrl)
                    }
                }
            },
            execCmd: function(command) {
                // var position = this.getCursorPosition()
                // console.log('execCmd calls and cursor pos = ' + position)
                // var tagnamestyle = document.getSelection().anchorNode.parentNode.tagName
                console.log('execCmd calls')
                document.execCommand(command, false, null)
            },
            tokenCSRF () {
                return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            returnFocusBack () {
                console.log('it returned!')

                richEditor.focus()
                if(richEditor.onfocus == true){
                    console.log('not in focus!!')
                    // co
                }else{
                    richEditor.focus()
                }
            },
            getCursorPosition() {
                console.log(document.getSelection().style)
                // var ctrl = RichED
                // var CaretPos = 0
                // if ( document.getSelection() && document.getSelection() != undefined ) {
                //     ctrl.focus ()
                //     var el = document.getSelection().createRange()
                //     el.moveStart ('character', -ctrl.value.length)
                //     CaretPos = el.text.length
                // } else if ( ctrl.selectionStart || ctrl.selectionStart == '0' ) {
                //     console.log(ctrl)
                //     CaretPos = ctrl.selectionStart
                // }
                return 'yaya position'
            },
            seeStyleOnTools () {
                // var lastParentNode = document.getSelection().anchorNode.parentNode
                // var tagnamestyle = lastParentNode.tagName.toLowerCase()

                var all_nodes_names = this.returnNotDivLastParentNodesNames(document.getSelection().anchorNode)

                // this.checkStyle()
                // console.log('checked!!! and style or parantnode tag is: ' + tagnamestyle)

                if(all_nodes_names.length == 0){
                    for(var prop in this.buttons_activity) {
                        this.buttons_activity[prop] = false
                    }
                }else{
                    for (let tagname of tag_names){
                        if (all_nodes_names.includes(tagname)){
                            this.buttons_activity[`${tagname}_active`] = true
                        }else{
                            this.buttons_activity[`${tagname}_active`] = false
                        }
                    }


                }
                // if(tag_names.includes(tagnamestyle)){
                //     this.buttons_activity[`${tagnamestyle}_active`] = true
                // }else{
                //     for(var prop in this.buttons_activity) {
                //         this.buttons_activity[prop] = false
                //     }
                    // this.buttons_activity = false
                // }

                // if (tagnamestyle == 'b'){
                //     console.log('da its tag b')
                //     console.log(this['buttons_activity'][`${tagnamestyle}_active`])
                //     console.log(`${tagnamestyle}_active`)
                //     this.#{tagnamestyle}_active
                    // this.buttons_activity.b_active = true
                // } else {
                //     this.buttons_activity.b_active = false
                // }
            },
            checkStyle () {
                var tagname = document.getSelection().anchorNode.parentNode.tagName.toLowerCase()
                if(tagname != 'div'){

                    // console.log('not a div!!!')
                } else {
                    console.log('anchornode: ' + document.getSelection().anchorNode.tagName)
                    console.log('parentnode: ' + document.getSelection().anchorNode.parentNode.tagName)
                    console.log('tag: ' + tagname)
                }
            },
            returnNotDivLastParentNodesNames (node) {
                var node_names = []
                var i = (node.tagName != undefined) ? node : node.parentNode
                console.log('NOT IN WHILE, i is: ' + i.tagName)

                while(i.tagName != 'DIV'){
                    node_names.push(i.tagName.toLowerCase())
                    i = i.parentNode
                }
                return node_names
            }

        }
    }
</script>


<style lang="scss" scoped>

    #richED{
        height: 200px;
        width: 500px;
        overflow-x: hidden;
        border: 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
        background: white;
    }

    body{
        overflow-x: hidden;

        /*margin: 0!important;*/
        /*padding: 0!important;*/
    }

    #richEditor{
        overflow-x: hidden;
        width: 500px;
        height: 500px;

        /*document{*/
            /*overflow-x: hidden;*/
        /*}*/

        body{
            overflow-x: hidden;
        }
    }

    iframe{

        overflow-x: hidden;
        border: 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
        background: white;
    }

    .edit-buttons{
        /*background: white;*/
        height: 40px;
        /*display: flex;*/
        /*justify-content: space-between;*/
        /*float: left;*/
        /*border:  2px solid #8a8a8a;*/
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
    }

    .edit-button{
        width: 25px;
        height: 25px;
        border: none;
        outline: none;
        /*margin: 0 !important;*/
        float: left;
        /*margin-left: 3px;*/
        /*margin-right: 3px;*/
        &:hover{
            background: transparent;
        }
    }

    .style_active{
        background: orange;
    }

    h1 {
        line-height: 1.5;
    }
    p {
        line-height: 1.5;
    }

    .edit-buttons-group{
        /*display: flex;*/
        /*justify-content: space-between;*/
        /*width: 77px;*/
        /*height: 25px;*/
    }

    .iconBox{
        /*margin: 0px 0px 0px 0.75px;*/
    }

    #imageEditButton{
        /*padding: 0px 0px 0px 0.75px;*/
    }

    .not-a-buttons-group{
        background: white;
    }

</style>
