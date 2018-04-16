<template>
    <div class="editable_content">
        <div class="edit-buttons">
            <div class="edit-buttons-group">
                <button class="edit-button">
                    <font-awesome-icon :icon="iconBold" @click="execCmd('bold')" class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button">
                    <font-awesome-icon :icon="iconItalic" @click="execCmd('italic')" class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button" id="imageEditButton">
                    <font-awesome-icon :icon="iconImage" @click="clickInputField" class="iconBox"></font-awesome-icon>
                </button>
            </div>
            <div class="not-a-buttons-group">
            </div>
        </div>

        <form action="/attachments/" method="post" contenteditable="false" enctype="multipart/form-data" name="attachment">
            <input @change="imgUploadAndInsert"  type="file" name="file" accept="image/*"  hidden/>
        </form>

        <iframe name="richEditor" id="richEditor" class="rich_editor" contenteditable="true" style="overflow-x:hidden;" >
        </iframe>

        <div class="saveAndPublic">
            <div class="saveContentAsPost" @click="saveAsPost">
                 <font-awesome-icon :icon="saveContent"></font-awesome-icon>
            </div>
        </div>

        <div id="richEditorDiv">
        </div>
    </div>
</template>

<script>
    import faImage from '@fortawesome/fontawesome-free-solid/faImage'
    import faSave from '@fortawesome/fontawesome-free-solid/faSave'
    import faBold from '@fortawesome/fontawesome-free-solid/faBold'
    import faItalic from '@fortawesome/fontawesome-free-solid/faItalic'

    export default {
        computed: {
            iconImage () {return faImage},
            iconBold () {return faBold},
            iconItalic () {return faItalic},
            saveContent () {return faSave}

        },
        mounted: function(){
            this.$nextTick(function () {
                richEditor.document.open();
                richEditor.document.close();
                richEditor.document.designMode = 'on'
                richEditor.focus()

            // var vc = this
            // vc.$on('blur', this.returnFocusBack())
            // if (document.querySelector('#editor-box')){
            //     console.log('document activated?: ' + vc.activated)
                // richEditor.focus()

            })
        },
        activated: function() {
          console.log('activated')
          // richEditor.document.open()
          // richEditor.document.close()
          // var eMouseOver = new Event('mouseover')
          // var eClick = new Event('click')
          // richEditor.dispatchEvent(eMouseOver)
          // richEditor.dispatchEvent(eClick)
          console.log('richEditor.document.designMode: ' + richEditor.document.designMode )
          console.log('richEditor.document.hasF ocus: ' + richEditor.document.hasFocus()        )
          // richEditor.document.designMode = 'on'
          // richEditor.document
          // richEditor.focus()
        },
        methods: {
            saveAsPost: function(){
                var content = richEditor.document.body.innerHTML
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

                        richEditor.document.execCommand('insertImage', false, fileUrl)
                    }
                }
            },
            execCmd: function(command) {
                richEditor.document.execCommand(command, false, null)
            },
            tokenCSRF () {
                return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            returnFocusBack () {
                console.log('it returned!')

                richEditor.focus()
                if(richEditor.onfocus == true){
                    console.log('not in focus!!')
                    co
                }else{
                    richEditor.focus()
                }
            }
        }
    }
</script>


<style lang="scss" scoped>

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
