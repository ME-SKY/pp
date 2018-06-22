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
            <input @change="imgUploadAndInsert" type="file" name="file" accept="image/*"  hidden/>
        </form>

        <div class="scoo_pee_dee_poo" style="height: 1000px; width: 1000px; border: 1px solid red; position: relative;" @mousemove="saveCoordinates" @mouseup="stop_resize_image" id="testresize">

            <div id="richED" ref="reditor"  @mouseup="seeStyleOnTools" @keydown.enter="addBR"  @keydown.delete="prevent_p_deletion" contenteditable="true" @mouseover="mouseOnEditor" @mouseout="mouseOffEditor" @click="makeAreaActive"  @keyup.delete="before_deletion" @keydown="char_counter" @keyup="char_counter">

                <p class="writer" :tabindex="1000"></p>
            </div>

            <div id='image_resizer' class="image_resizer" :style="test_resizer_data" tabindex="105">
                <div class="resize_handlers top_left_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers top_right_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers down_left_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers down_right_handler" @mousedown="resize_image"></div>
            </div>
        </div>


        <div class="saveAndPublic">
            <div class="saveContentAsPost" @click="saveAsPost">
                 <font-awesome-icon :icon="saveContent"></font-awesome-icon>
            </div>
        </div>
    </div>
</template>

<script>
    import faImage from '@fortawesome/fontawesome-free-solid/faImage'
    import faSave from '@fortawesome/fontawesome-free-solid/faSave'
    import faBold from '@fortawesome/fontawesome-free-solid/faBold'
    import faItalic from '@fortawesome/fontawesome-free-solid/faItalic'
    import { fabric } from 'fabric'

    var tag_names = ['b', 'i']
    var this_vc, tokenCSRF, imageResizer, imgResizerHandlers, currentResizingImage

    export default {
        data: function(){
          return {
              p_tab_index_int: 1000,
              // mouse_over_resizer: false,
              abcdefg: 0,
              mouse_over_image_resizer: false,
              max_image_width: '799px',
              active_image: {
                  url:'',
                  max_width: 0
              },
              mouseupped_on_image_resizer: false,
              mouse_down_on_IRH: false,
              mouse_on_editor: false,
              hidePlaceholderSpan: false,
              rich_text: '',
              rich_text_count: 0,
              width: 0,
              height: 0,
              test_resizer_data: {
                  handler: '',
                  width: '300px',
                  height: '300px',
                  top: '500px',
                  left: '400px',
                  maxWidth: '798px',
                  image: {
                      url: '',
                      x1_old: '',
                      x1_lt: '',
                      x2_rt: '',
                      x3_lb: '',
                      x4_rb: '',
                      y1_lt: '',
                      y2_rt: '',
                      y3_lb: '',
                      y4_rb: ''
                  }
              },
              cursor:{
                  position: { x: 0, y: 0 }
              },
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
            saveContent () {return faSave},
            placeholderShow () {
                if (this.rich_text.length != 0){
                    this.showPlaceholderSpan = false
                } else {
                    this.showPlaceholderSpan = true
                }
                return this.showPlaceholderSpan
            },
            reverseRichText () {
                return this.rich_text.split('').reverse().join('')
            }
        },
        mounted: function(){
            document.execCommand("defaultParagraphSeparator", false, "p") // set default paragraph separator to '<p>'

            this_vc = this
            tokenCSRF = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            imageResizer = document.querySelector('#image_resizer')

            imageResizer.onfocus = () => {
                this_vc.switch_resizer_mode('active')
            }

            imageResizer.onblur = (e) => {
                if(e.relatedTarget){
                    if(e.relatedTarget.nodeName != 'IMG'){
                        this_vc.switch_resizer_mode()
                    }
                }else{
                    this_vc.switch_resizer_mode()
                }
            }

            var imageObserver = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {

                    if(mutation.addedNodes.length > 0){
                        var imageNode =  mutation.addedNodes['0']

                        if(imageNode.nodeName == 'P'){
                            imageNode.setAttribute('tabindex', `${++this_vc.p_tab_index_int}`)
                        }

                        if(imageNode.nodeName == 'IMG' && !imageNode.classList.contains('active_img')){
                            imageNode.addEventListener('load', () => {
                                this_vc.new_prepare_for_resizing(imageNode)
                                let imgsLength = this_vc.$refs.reditor.querySelectorAll('img').length
                                imageNode.setAttribute('tabindex', `${110 + imgsLength}`)
                                imageNode.onfocus = e => {
                                    currentResizingImage = imageNode
                                    this_vc.set_img_resizer_params(imageNode, 'active')
                                }
                                imageNode.onblur = e => {
                                    this_vc.switch_resizer_mode()
                                }
                            }, UIEvent)
                        }
                    }
                });
            });

            imageObserver.observe(
                document.getElementById('richED'),
                {
                    childList: true,
                    subtree: true
                }
            );

        },
        methods: {
            char_counter: function(e){

                var reditor = this_vc.$refs.reditor

                if(reditor.hasChildNodes()){

                    var presumablyEditableP = reditor.lastChild

                    if(reditor.lastChild.nodeType !== Node.TEXT_NODE){
                        if(presumablyEditableP){
                            this.rich_text_count = presumablyEditableP.innerText.length
                        }
                    }
                }

            },
            new_prepare_for_resizing(resized_img){
                resized_img.className = 'active_img'
                resized_img.className += ' res_img'
                resized_img.className += ' inserted_image'

                resized_img.style.verticalAlign = 'top'
                resized_img.style.maxWidth = this_vc.max_image_width
                resized_img.style.display = 'block'
                resized_img.style.outline = 'none'

                if(getComputedStyle(resized_img).paddingTop === '16px'){ resized_img.style.paddingTop = '0' }
            },
            addBR: function(e){
                if(e.target.children.length === 1){
                    if(!e.target.lastChild.hasChildNodes()){
                        var brTag = document.createElement('br')
                        e.target.lastChild.appendChild(brTag)
                    }
                }
            },
            prevent_p_deletion: function(e){
//new code
                if(this_vc.$refs.reditor.children.length <= 1){

                    var editableP = this_vc.$refs.reditor.lastChild

                    if(editableP){
                        if(editableP.lastChild){
                            if(editableP.lastChild.nodeValue == null){
                                e.preventDefault()
                            }
                        }else{
                            e.preventDefault()
                        }
                    }
                }
            },
            before_deletion: function(){
                if(this_vc.$refs.reditor.children.length === 1){

                    var editableP = this_vc.$refs.reditor.firstChild

                    if(!editableP.isContentEditable){

                        editableP.contentEditable = true

                        if(editableP.innerText.length <= 1){
                            editableP.innerText = ''
                        }
                    }else {

                        if(editableP.firstChild != null){
                            if(editableP.firstChild.tagName === 'BR') {
                                editableP.firstChild.remove()
                            }
                        }

                    }
                }

            },
            makeAreaActive: function(){
                var docArea = this_vc.$refs.reditor.firstChild
                var p_tag_quantity = this_vc.$refs.reditor.children.length

                if(this.mouse_on_editor && p_tag_quantity === 1){
                    docArea.focus()
                }
            },
            mouseOnEditor: function(){
                this.mouse_on_editor = true
            },
            mouseOffEditor: function(){
                this.mouse_on_editor = false
            },
            saveCoordinates: function(e){
                if(this_vc.mouse_down_on_IRH){

                    var testResizeDiv = document.getElementById('testresize');
                    this_vc.cursor.position.x = e.clientX - testResizeDiv.offsetLeft
                    this_vc.cursor.position.y = e.clientY - testResizeDiv.offsetTop

                    var resizeFromLeftSide = this_vc.test_resizer_data.handler.search('left') != -1

                     ++this_vc.abcdefg

                    var x_start = parseInt(resizeFromLeftSide ? this_vc.test_resizer_data.left : this_vc.test_resizer_data.image.x2_rt)
                    var  x_old =  isNaN(parseInt(this_vc.test_resizer_data.image.x1_old)) ? x_start : parseInt(this_vc.test_resizer_data.image.x1_old, 10)
                    var x_new = this_vc.cursor.position.x // это не нужно наверное
                    var width_old = parseInt(this_vc.test_resizer_data.width) // это тоже не нужно наверное
                    var resizedImage = currentResizingImage

                    this_vc.test_resizer_data.width =  resizeFromLeftSide ? `${width_old - (x_new - x_old)}px` : `${width_old + (x_new - x_old)}px`
                    resizedImage.style.width = `${parseInt(this_vc.test_resizer_data.width) + 1}px`

                    this_vc.test_resizer_data.height = `${parseInt(getComputedStyle(resizedImage).height) - 1}px`
                    this_vc.test_resizer_data.image.x1_old = `${x_new}px`
                    this_vc.test_resizer_data.image.x2_rt = `${parseInt(this_vc.test_resizer_data.left) + parseInt(this_vc.test_resizer_data.width)}px`
                }
            },
            saveAsPost: function(){
                var content = this_vc.$refs.reditor.innerHTML
                var formData = new FormData()
                var xhr = new XMLHttpRequest()

                xhr.open("POST", "/posts/")
                xhr.setRequestHeader('X-CSRF-Token', tokenCSRF)

                formData.append("content", content)
                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        this_vc.$root.$emit('newPostIsCreated', respText)
                    }
                }
            },
            clickInputField: function() {
                document.querySelector('input[name="file"]').click()
            },
            imgUploadAndInsert: function (e) {
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', tokenCSRF)

                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        var fileUrl = respText.file.url
                        document.execCommand('insertImage', false, fileUrl)
                    }
                }
            },
            execCmd: function(command) {
                document.execCommand(command, false, null)
            },
            tokenCSRF () { // make it variable
                return document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            },
            seeStyleOnTools () {
                var editableP
                var reditor = this_vc.$refs.reditor

                if(reditor.hasChildNodes()){
                    editableP = reditor.firstChild

                    var all_nodes_names = this_vc.returnNotDivLastParentNodesNames(document.getSelection().anchorNode)

                    if(all_nodes_names.length == 0){
                        for(var prop in this.buttons_activity) {
                            this.buttons_activity[prop] = false
                        }
                    }else{
                        for (let tagname of tag_names){
                            if (all_nodes_names.includes(tagname)){
                                this_vc.buttons_activity[`${tagname}_active`] = true
                            }else{
                                this_vc.buttons_activity[`${tagname}_active`] = false
                            }
                        }
                    }
                }
            },
            returnNotDivLastParentNodesNames (node) {
                var node_names = []
                if(node != null){
                    var i = (node.tagName != undefined) ? node : node.parentNode

                    while(i.tagName != 'DIV' && i.tagName!= undefined && i.tagName != 'CANVAS'){
                        node_names.push(i.tagName.toLowerCase())
                        i = i.parentNode
                    }
                }
                return node_names
            },
            setImageAreaProps: function(e){
                this_vc.set_resizer_data(e.target)
            },
            set_resizer_data(data_source_el){
                this_vc.test_resizer_data.top = `${data_source_el.offsetTop}px`
                this_vc.test_resizer_data.left = `${data_source_el.offsetLeft}px`
                this_vc.test_resizer_data.height = `${data_source_el.height - 1}px`
                this_vc.test_resizer_data.width = `${data_source_el.width - 1}px`
                this_vc.test_resizer_data.image.x1_lt = `${parseInt(this_vc.test_resizer_data.left, 10)}px`
                this_vc.test_resizer_data.image.x2_rt = `${parseInt(this_vc.test_resizer_data.left, 10) + parseInt(this_vc.test_resizer_data.width, 10)}px`
            },
            set_img_resizer_params(img_element, resizer_mode){
                imgResizerHandlers = document.querySelectorAll('.resize_handlers')

                this_vc.set_resizer_data(img_element)
                this_vc.switch_resizer_mode(resizer_mode)
            },
            switch_resizer_mode(mode = 'default'){
                switch (mode){
                    case 'active':
                        imageResizer.classList.remove('sleep')
                        imageResizer.classList.add('its_active')
                        imgResizerHandlers.forEach(function(el){ el.classList.remove('inactive')})
                        break
                    case 'sleep':
                        imageResizer.classList.remove('its_active')
                        imageResizer.classList.add('sleep')
                        imgResizerHandlers.forEach(function(el){ el.classList.add('inactive')})
                        break
                    default:
                        if(imageResizer.classList.contains('sleep')){
                            imageResizer.classList.remove('sleep')
                            imageResizer.classList.add('its_active')
                            imgResizerHandlers.forEach(function(el){ el.classList.remove('inactive') })
                        } else {
                            imageResizer.classList.remove('its_active')
                            imageResizer.classList.add('sleep')
                            imgResizerHandlers.forEach(function(el){ el.classList.add('inactive') })
                        }
                        break
                }
            },
            resize_image: function(e){
                this_vc.mouse_down_on_IRH = true
                this_vc.test_resizer_data.handler = e.target.classList[e.target.classList.length - 1]
                console.log(`resize_image, this_vc.test_resizer_data.handler: ${this_vc.test_resizer_data.handler}`)
            },
            stop_resize_image: function(e){
                if(this_vc.mouse_down_on_IRH === true){
                    this_vc.mouse_down_on_IRH = false
                    console.log('stop_resize_image')
                    this_vc.test_resizer_data.image.x1_old = ''
                    this_vc.test_resizer_data.handler = ''
                }
            },
            tester_function: function(e){
                console.log('tester function e.target')
                console.dir(e.target)
                console.log('tester function event.target')
                console.dir(event.target)
            }
        }
    }
</script>


<style lang="scss" scoped>

    .scoo_pee_dee_poo{
        white-space: pre-wrap;
        word-wrap: break-word;
    }

    .inserted_image{
        vertical-align: top;
    }

    .image_resizer{
        tab-index: 100;
        position: absolute;
        border: solid 1px #1e88e5;
        display: none;
        user-select: none;
        box-sizing: content-box;
        max-width: 800px;

        &.its_active{
            display: block
        }

        &.sleep{
            display: block;
            border: none;
        }

        &:focus{
            outline: none;
            /*border: none;*/
        }
    }

    .image_is_here{
        position: absolute;
    }

    .resize_handlers{
        display: block;
        position: absolute;
        width: 10px;
        height: 10px;
        background: #1e88e5;
        border: solid 1px #ffffff;
        box-sizing: border-box;

        &.top_left_handler{
            top: -5px;
            left: -5px;
            cursor: nw-resize;
        }

        &.top_right_handler{
            top: -5px;
            right: -5px;
            cursor: ne-resize;
        }

        &.down_left_handler{
            bottom: -5px;
            left: -5px;
            cursor: sw-resize;
        }

        &.down_right_handler{
            bottom: -5px;
            right: -5px;
            cursor: se-resize;
        }

        &.inactive{
            display: none;
            pointer-events: none;
        }
    }

    #placeholder2{ // second example
        display: block;
        pointer-events: none;
        top: 20px;
        position: absolute;
        z-index: 1;
        outline: none;


    }

    .heightone{
        z-index: -1;
        outline: none;
        /*overflow: inherit;*/
        /*box-sizing: content-box;*/
        border: none;
        width: 100%;
        height: 100%;

        p{
            outline: none;
            box-sizing: content-box;
            border: none;
        }

        &:focus{
            outline: none;
            border: none;
        }


    }

    .hidden_span{
        visibility: hidden;
    }

    .placeholderSpan{
        display: block;
        pointer-events: none;
        font-size: 16px;
        line-height: 24px;
        margin-top: 0px;
        padding-top: 16px;
        padding-left: 16px;
        margin-left: 0px;
        padding-right: 16px;
        margin-right: 0px;
        text-align: left;
        position: absolute;
        color: #aaaaaa;
        z-index: 1;
        top: 0;
        left: 0;
        right: 0;
        overflow: hidden;
    }

    #richED{
        position: relative;
        box-sizing: content-box;
        min-height: 399px;
        width: 800px;
        height: auto;
        overflow: hidden;
        border: 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
        background: white;
        outline: none;
        padding: 0px 16px 16px;
        font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;

        & :only-child{
            margin: 0;
            padding-top: 16px;
            z-index: 2;
        }

        & :only-child:after{
            content: '';
            position: absolute;
        }

        & :only-child:empty:after{
            content: 'ТАЙПХИР!';
            position: absolute;
            color: rgba(28, 28, 28, 0.45);
        }

    }

    .resizableImg{
        resize: both;
        overflow: hidden;
    }

    body{

    }


    iframe{

        overflow-x: hidden;
        border: 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
        background: white;
    }

    .edit-buttons{
        height: 40px;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
    }

    .edit-button{
        width: 25px;
        height: 25px;
        border: none;
        outline: none;
        float: left;
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
        text-align: left;
        vertical-align: middle;
        line-height: 1.5;
        margin: 16px 0 0;
    }

    .edit-buttons-group{
    }

    .iconBox{
    }

    #imageEditButton{
    }

    .not-a-buttons-group{
        background: white;
    }

    .canvas_example{
        border: 1px green;
    }

    .res_img{
        object-fit: contain;

        &:focus{
            outline: none;
            user-select: none;
        }
    }

    .writer{
        outline: none;
    }

</style>
