<template>

    <div class="editor_block">


        <div class="preview_block">
            <!-- background for post preview insert this -->

        </div>

        <div class="edit-buttons">

            <div class="edit-buttons-group">
                <button class="edit-button" @click="execCmd('bold')" :class="{ style_active: buttons_activity.b_active}">
                    <font-awesome-icon :icon="iconBold" class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button" @click="execCmd('italic')" :class="{ style_active: buttons_activity.i_active}">
                    <font-awesome-icon :icon="iconItalic"  class="iconBox"></font-awesome-icon>
                </button>

                <button class="edit-button" id="imageEditButton" @click="click_on_input_field" >
                    <font-awesome-icon :icon="iconImage" class="iconBox"></font-awesome-icon>
                </button>
            </div>

            <div class="not-a-buttons-group">
            </div>
        </div>

        <form action="/attachments/" method="post" contenteditable="false" enctype="multipart/form-data" name="attachment">
            <input @change="insert_image" type="file" name="file" accept="image/*"  hidden/>
        </form>

        <div style="width: 1000px; position: relative;"  id="editable_area">

            <div id="richED" ref="reditor"  @mouseup="show_formatting_styles" @keydown.enter="add_br"  @keydown.delete="prevent_p_deletion" contenteditable="true" @mouseover="mouse_on_editor = true" @mouseout="mouse_on_editor = false" @click="activate_area"  @keyup.delete="before_deletion">

                <p class="writer" :tabindex="magic_numbers.p_tab_index"></p>
            </div>

            <div id='image_resizer' class="image_resizer" :style="resizer_data" tabindex="105">
                <div class="resize_handlers top_left_handler" @mousedown="start_resize_image"></div>
                <div class="resize_handlers top_right_handler" @mousedown="start_resize_image"></div>
                <div class="resize_handlers down_left_handler" @mousedown="start_resize_image"></div>
                <div class="resize_handlers down_right_handler" @mousedown="start_resize_image"></div>
            </div>
        </div>


        <div class="saveAndPublic">
            <div class="saveContentAsPost" @click="publish_content">
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
    var this_vc,
        token_csrf,
        image_resizer,
        resizer_handlers,
        current_resizable_img,
        editable_area;

    export default {
        data: function(){
          return {
              magic_numbers: {
                  p_tab_index: 1000,
                  img_tab_index: 100
              },
              max_image_width: '967px',
              mouse_down_on_resize_handler: false,
              mouse_on_editor: false,
              mouse_on_image: false,
              mouse_on_image_resizer: false,
              width: 0,
              height: 0,
              resizer_data: {
                  handler: '',
                  width: '300px',
                  height: '300px',
                  top: '500px',
                  left: '400px',
                  maxWidth: '966px',
                  image: {
                      x1_old: '',
                      x1_lt: '',
                      x2_rt: ''
                  }
              },
              calculation_data:{
                width: 300,
                height: 300,
                top: 500,
                left: 400,
                x1_old: 0,
                x1_lt: 0,
                x2_rt: 0
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
        },
        mounted: function(){
            document.execCommand("defaultParagraphSeparator", false, "p") // set default paragraph separator to '<p>'

            this_vc = this
            token_csrf = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            image_resizer = document.querySelector('#image_resizer')
            resizer_handlers = document.querySelectorAll('.resize_handlers')
            editable_area = document.querySelector('#editable_area')

            document.addEventListener('mousemove', this_vc.save_coordinates)
            document.addEventListener(('mouseup'), this_vc.stop_resize_image)

            image_resizer.onfocus = () => { this_vc.switch_resizer_mode('active') }

            image_resizer.onblur = e => {
                if(e.relatedTarget){
                    if(e.relatedTarget.nodeName != 'IMG' && e.relatedTarget.id !== 'image_resizer'){
                        this_vc.switch_resizer_mode()
                        this_vc.stop_resize_image()
                    }
                }else{
                    this_vc.switch_resizer_mode()
                    this_vc.stop_resize_image()
                }
            }

            image_resizer.onmouseover = e => { this_vc.mouse_on_image_resizer = true }
            image_resizer.onmouseout = e => { this_vc.mouse_on_image_resizer = false }

            var editor_obs = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {

                    if(mutation.addedNodes.length > 0){
                        var imageNode =  mutation.addedNodes['0']

                        if(imageNode.nodeName == 'P'){
                            imageNode.setAttribute('tabindex', `${++this_vc.magic_numbers.p_tab_index}`)
                        }

                        if(imageNode.nodeName == 'IMG' && !imageNode.classList.contains('new_inserted_img')){
                            imageNode.addEventListener('load', () => {

                                this_vc.prepare_for_resizing(imageNode)
                                let imgsLength = this_vc.$refs.reditor.querySelectorAll('img').length
                                imageNode.setAttribute('tabindex', `${this_vc.magic_numbers.img_tab_index + imgsLength}`)

                                imageNode.onmousedown = e => {
                                    current_resizable_img = imageNode
                                    this_vc.set_img_resizer_params(imageNode, 'active')
                                }

                                imageNode.onmouseover = () => { this_vc.mouse_on_image = true }
                                imageNode.onmouseout = () => { this_vc.mouse_on_image = false }
                                imageNode.onblur = e => {

                                    if(e.relatedTarget){
                                        if(e.relatedTarget.nodeName !== 'IMG' && e.relatedTarget.id !== 'image_resizer'){
                                            this_vc.switch_resizer_mode('sleep')
                                        }else{
                                            image_resizer.focus()
                                        }
                                    }else{
                                        this_vc.switch_resizer_mode('sleep')
                                    }
                                }
                            }, UIEvent)
                        }
                    }
                });
            });

            editor_obs.observe(
                document.getElementById('richED'),
                {
                    childList: true,
                    subtree: true
                }
            );

        },
        destroyed: function(){
            document.removeEventListener('mousemove', this_vc.save_coordinates)
            document.removeEventListener('mouseup', this_vc.stop_resize_image)
        },
        methods: {
            prepare_for_resizing(resized_img){
                resized_img.className = 'new_inserted_img'
                resized_img.className += ' res_img'
                resized_img.className += ' inserted_image'

                resized_img.style.verticalAlign = 'top'
                resized_img.style.maxWidth = this_vc.max_image_width
                resized_img.style.display = 'block'
                resized_img.style.outline = 'none'

                if(getComputedStyle(resized_img).paddingTop === '16px'){ resized_img.style.paddingTop = '0' }
            },
            add_br: function(e){
                if(e.target.children.length === 1){
                    if(!e.target.lastChild.hasChildNodes()){
                        var brTag = document.createElement('br')
                        // brTag.contentEditable = true
                        e.target.lastChild.appendChild(brTag)
                    }
                }
            },
            prevent_p_deletion: function(e){

                console.log('on deletion')
                if(this_vc.$refs.reditor.children.length <= 1){
                    console.log('this_vc.$refs.reditor.children.length <= 1 is TRUE')
                    var editableP = this_vc.$refs.reditor.lastChild


                    //newcode
                    if(editableP) {
                        if(editableP.lastChild) {
                            if(editableP.lastChild.nodeValue == null || !editableP.lastChild.nodeName === 'BR') {
                                e.preventDefault()
                            }
                        }else{
                            e.preventDefault()
                        }
                    }
                    //oldcode
                    // if(editableP){
                    //     if(editableP.lastChild){
                    //         if(editableP.lastChild.nodeValue == null){
                    //             if(!editableP.lastChild.nodeName === 'BR'){
                    //                 e.preventDefault()
                    //             }
                    //
                    //         }
                    //     }else{
                    //         e.preventDefault()
                    //     }
                    // }
                }
            },
            before_deletion: function(){
                console.log('before_deletion')
                if(this_vc.$refs.reditor.children.length === 1){

                    var editableP = this_vc.$refs.reditor.firstChild

                    if(!editableP.isContentEditable){

                        editableP.contentEditable = true

                        if(editableP.innerText.length <= 1){
                            editableP.innerText = ''
                        }
                    }else {
                        if(editableP.firstChild != null && editableP.firstChild.tagName === 'BR'){
                            editableP.firstChild.remove()
                        }
                    }
                }

            },
            activate_area: function(){
                var docArea = this_vc.$refs.reditor.firstChild
                var p_tag_quantity = this_vc.$refs.reditor.children.length

                if(this.mouse_on_editor && p_tag_quantity === 1){
                    docArea.focus()
                }
            },
            save_coordinates(e){
                if(this_vc.mouse_down_on_resize_handler){

                    this_vc.cursor.position.x = e.clientX - editable_area.offsetLeft
                    this_vc.cursor.position.y = e.clientY - editable_area.offsetTop

                    let resize_from_left_side = this_vc.resizer_data.handler.search('left') != -1
                    let x_start = resize_from_left_side ? this_vc.calculation_data.left : this_vc.calculation_data.x2_rt

                    let x_old = this_vc.calculation_data.x1_old ? this_vc.calculation_data.x1_old : x_start
                    let x_new = this_vc.cursor.position.x
                    let width_old = this_vc.calculation_data.width

                    let data_width = resize_from_left_side ? width_old - (x_new - x_old) : width_old + (x_new - x_old)

                    this_vc.resizer_data.width = `${data_width}px`
                    this_vc.calculation_data.width = data_width
                    current_resizable_img.style.width = `${data_width + 1}px`

                    this_vc.resizer_data.height = `${parseInt(getComputedStyle(current_resizable_img).height) - 1}px`
                    this_vc.calculation_data.x1_old = x_new
                    this_vc.calculation_data.x2_rt = this_vc.calculation_data.left + this_vc.calculation_data.width

                }
            },
            publish_content: function(){
                let content = this_vc.$refs.reditor.innerHTML
                let formData = new FormData()
                var xhr = new XMLHttpRequest()

                xhr.open("POST", "/posts/")
                xhr.setRequestHeader('X-CSRF-Token', token_csrf)

                formData.append("content", content)
                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        var respText = JSON.parse(xhr.responseText)
                        this_vc.$root.$emit('newPostIsCreated', respText)
                    }
                }
            },
            prepare_content_to_publish(){
                let elements = this_vc.$refs.reditor.querySelectorAll('img')
                elements.forEach(function(e){ e.classList.remove('new_inserted_img') })
                // TODO write code to removing classes from all images in redactor
            },
            click_on_input_field: function() {
                document.querySelector('input[name="file"]').click()
            },
            insert_image(){
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', token_csrf)

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
            show_formatting_styles () {
                var editableP
                var reditor = this_vc.$refs.reditor

                if(reditor.hasChildNodes()){
                    editableP = reditor.firstChild

                    var all_nodes_names = this_vc.last_parent_node_names(document.getSelection().anchorNode)

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
            last_parent_node_names (node) {
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
            set_resizer_data(data_source_el){
                this_vc.resizer_data.top = `${data_source_el.offsetTop}px`
                this_vc.resizer_data.height = `${data_source_el.height - 1}px`

                this_vc.resizer_data.left = `${data_source_el.offsetLeft}px`
                this_vc.calculation_data.left = data_source_el.offsetLeft

                this_vc.resizer_data.width = `${data_source_el.width - 1}px`
                this_vc.calculation_data.width = data_source_el.width

                this_vc.calculation_data.x1_lt = this_vc.calculation_data.left
                this_vc.calculation_data.x2_rt = this_vc.calculation_data.left + this_vc.calculation_data.width
            },
            set_img_resizer_params(img_element, resizer_mode){
                this_vc.set_resizer_data(img_element)
                this_vc.switch_resizer_mode(resizer_mode)
            },
            switch_resizer_mode(mode = 'default'){
                console.log(`switch_resizer_mode, mode: ${mode}`)
                console.log(`image_resizer.classList.contains('sleep'): ${image_resizer.classList.contains('sleep')}`)
                switch (mode){
                    case 'active':
                        image_resizer.classList.remove('sleep')
                        image_resizer.classList.add('its_active')
                        resizer_handlers.forEach(function(el){ el.classList.remove('inactive')})
                        break
                    case 'sleep':
                        image_resizer.classList.remove('its_active')
                        image_resizer.classList.add('sleep')
                        resizer_handlers.forEach(function(el){ el.classList.add('inactive')})
                        break
                    default:
                        if(image_resizer.classList.contains('sleep')){
                            console.log(`image_resizer.classList.contains('sleep'): ${image_resizer.classList.contains('sleep')}`)
                            image_resizer.classList.remove('sleep')
                            image_resizer.classList.add('its_active')
                            resizer_handlers.forEach(function(el){ el.classList.remove('inactive') })
                        } else {
                            image_resizer.classList.remove('its_active')
                            image_resizer.classList.add('sleep')
                            resizer_handlers.forEach(function(el){ el.classList.add('inactive') })
                        }
                        break
                }
            },
            start_resize_image: function(e){
                this_vc.mouse_down_on_resize_handler = true
                this_vc.resizer_data.handler = e.target.classList[e.target.classList.length - 1]
            },
            stop_resize_image: function(e){
                console.log('stop_resize_image')
                console.log(`activeElement: ${document.activeElement}`)
                if(this_vc.mouse_down_on_resize_handler === true){
                    this_vc.mouse_down_on_resize_handler = false
                    this_vc.calculation_data.x1_old = 0
                    this_vc.resizer_data.handler = ''
                }
            }
        }
    }
</script>


<style lang="scss" scoped>

    #editable_area{
        box-sizing: content-box;
        height: content-box;
        white-space: pre-wrap;
        word-wrap: break-word;
    }

    .inserted_image{
        vertical-align: top;
    }

    .image_resizer{
        /*tab-index: 100;*/
        position: absolute;
        border: solid 1px #1e88e5;
        display: none;
        user-select: none;
        box-sizing: content-box;
        max-width: 970px;

        &.its_active{
            display: block
        }

        &.sleep{
            border: none;
        }

        &:focus{
            outline: none;
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

    #richED{
        position: relative;
        box-sizing: content-box;
        min-height: 399px;
        width: 967px;
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

    .not-a-buttons-group{
        background: white;
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
