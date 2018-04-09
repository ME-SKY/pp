<template>
    <div class="editable_content">
        <div class="edit-buttons">
            <div @click="clickInputField">
                <font-awesome-icon :icon="iconImage"></font-awesome-icon>
            </div>
        </div>
        <form action="/attachments/" method="post" contenteditable="false" enctype="multipart/form-data" name="attachment">
            <input @change="imgUploadAndInsert"  type="file" name="file" accept="image/*"  hidden/>
        </form>
        <iframe name="richEditor" id="richEditor" class="rich_editor">

        </iframe>
        <div class="saveAndPublic">
            <div class="saveContentAsPost" @click="saveAsPost">
                 <font-awesome-icon :icon="saveContent"></font-awesome-icon>
            </div>
        </div>
    </div>
</template>

<script>
//    import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
    import faImage from '@fortawesome/fontawesome-free-solid/faImage'
    import faSave from '@fortawesome/fontawesome-free-solid/faSave'

    export default {
//        components: {
//            FontAwesomeIcon
//        },
        computed: {
            iconImage () {
                return faImage
            },
            saveContent () {
                return faSave
            }
        },
        mounted: function(){
            richEditor.document.designMode = 'on'
        },
        methods: {
            saveAsPost: function(){
                var content = richEditor.document.body.innerHTML
                var formData = new FormData()
                var xhr = new XMLHttpRequest()
                var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

                xhr.open("POST", "/posts/")
                xhr.setRequestHeader('X-CSRF-Token', token)

                formData.append("content", content)
                xhr.send(formData)
            },
            clickInputField: function() {
                document.querySelector('input[name="file"]').click()
            },
            imgUploadAndInsert: function (e) {
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()
                var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', token)

                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        var fileUrl = respText.file.url

                        richEditor.document.execCommand('insertImage', false, fileUrl)
                    }
                }
            }
        }
    }
</script>


<style lang="scss" scoped>
    #richEditor{
        width: 500px;
        height: 500px;
    }
</style>