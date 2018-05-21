<template>

    <div class="editable_content">

        <div style="height: 1000px; width: 1000px; border: 1px solid red; position: relative;" @mousemove="saveCoordinates" @mouseup="stop_resize_image" id="testresize" >
            <div>
                x {{ cursor.position.x }}, y {{ cursor.position.y }}
            </div>

            <p class="image_is_here" @mousedown="resize_motherfucker" style="left: 20px;"></p>

            <div id='image_resizer' class="image_resizer" :style="test_resizer_data" >
                <div class="resize_handlers top_left_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers top_right_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers down_left_handler" @mousedown="resize_image"></div>
                <div class="resize_handlers down_right_handler" @mousedown="resize_image"></div>
            </div>
        </div>

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

        <div id="richED" ref="reditor"  @mouseup="seeStyleOnTools" @keydown.enter="addBR"  @keydown.delete="prevent_p_deletion" contenteditable="true" @mouseover="mouseOnEditor" @mouseout="mouseOffEditor" @click="makeAreaActive"  @keyup.delete="before_deletion" @keydown="char_counter" @keyup="char_counter">

            <p class="writer"></p>
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
    var this_vc, tokenCSRF, imageResizer

    export default {
        data: function(){
          return {
              abcdefg: 0,
              cursor_over_image_resizer: false,

              // active_image: {
              //     url: '',
              //     wi: 30,
              //     he: 30,
              //     changed_width: 0,
              //     changed_height: 0
              // },
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
                  image: {
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
                console.log('it works placeholderShow')
                console.log('rich_text: '  + this.rich_text)
                if (this.rich_text.length != 0){
                    console.log('this.rich_text.length != 0 is true and rich_text is: ' + this.rich_text)
                    this.showPlaceholderSpan = false
                } else {
                    this.showPlaceholderSpan = true
                }
                return this.showPlaceholderSpan
            },
            reverseRichText () {
                console.log('reverseRichText')
                return this.rich_text.split('').reverse().join('')
            }
        },
        mounted: function(){
            document.execCommand("defaultParagraphSeparator", false, "p")
            tokenCSRF = document.querySelector('meta[name="csrf-token"]').getAttribute('content')
            this_vc = this
            imageResizer = document.querySelector('#image_resizer')


            // var imageResizeArea = document.querySelector('#testresize')



            // imageResizeArea.onclick = function(event){
            //     console.log('event_target')
            //     console.dir( event.target)
            // }

            var observer = new MutationObserver(function(mutations) {
                mutations.forEach(function(mutation) {
                    if(mutation.addedNodes.length > 0){
                        console.log(mutation.addedNodes['0'])
                        // if(mutation.addedNodes['0'] == 'img.active_img'){
                        var imageNode =  mutation.addedNodes['0']
                        console.log(`imageNode.nodeName is: ${imageNode.nodeName}, imageNode.classList is: ${imageNode.classList}`)
                        if(imageNode.nodeName == 'IMG' && !imageNode.classList.contains('active_img')){
                            console.dir(mutation)
                            var image_src = imageNode.attributes.src.value
                            imageNode.onload = this_vc.prepare_for_resizing(image_src)
                        }
                    }
                });
            });

            observer.observe(
                document.getElementById('richED'),
                {
                    childList: true,
                    subtree: true
                }
            );
        },
        watch: {
            abcdefg: function(){
                console.log('свойство было обновлено!!!')
              
          }  
        },
        methods: {
            char_counter: function(e){

                //new code

                var reditor = this_vc.$refs.reditor

                if(reditor.hasChildNodes()){

                    var presumablyEditableP = reditor.lastChild

                    if(reditor.lastChild.nodeType !== Node.TEXT_NODE){
                        if(presumablyEditableP){
                            this.rich_text_count = presumablyEditableP.innerText.length
                        }
                    }
                }
                //

                // if(e.keyCode === 13){
                //     console.log('!!! ENTER is down on up !!!')
                // }


                // console.log('richParamChange: hasChildNodes is: '+ document.querySelector('#richED').hasChildNodes())

                // if(document.querySelector('#richED').hasChildNodes()){
                //     var presumablyEditableP = document.querySelector('#richED').lastChild
                //     if(document.querySelector('#richED').lastChild.nodeType === Node.TEXT_NODE){
                //         console.log('OOOPS!')
                //     }else{
                //         presumablyEditableP = document.querySelector('#richED').lastChild
                //         if(presumablyEditableP){ this.rich_text_count = presumablyEditableP.innerText.length }
                //         console.log('rich_text_count = ' + this.rich_text_count)

                    // }
                    // var editableP = document.querySelector('#richED').lastChild
                    // if(editableP){ this.rich_text_count = editableP.innerText.length }
                    // console.log('rich_text_count = ' + this.rich_text_count)
                // }
            },
            // bum: function(){
            //     console.log('BBBBBBBBBBB UUUUUUUUU MMMMMM!!!!!!!!!!!!!')
            // },
            addBR: function(e){
                if(e.target.children.length === 1){
                    console.log('p tag quantity is 1')
                    if(!e.target.lastChild.hasChildNodes()){
                        console.log('p tag have dont have children')
                        var brTag = document.createElement('br')
                        e.target.lastChild.appendChild(brTag)
                    }
                }
            },
            // deleteBR: function(targetP){
            //     console.log('delete br')
            // },
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


                // console.log('check char count')
                // console.log('#richED children length is: ' + e.target.children.length)
                // if(this_vc.$refs.reditor.children.length <= 1){

                    // var editableP = this_vc.$refs.reditor.lastChild

                    // if(editableP){
                        // if(editableP.isContentEditable){ console.log('checkCharCount: P is ContentEditable') }
                        // if(!editableP){
                        //     console.log('editableP undefined: ')
                            // e.stopPropagation()
                        // }
                        // if(editableP.innerText.length === 1){
                        //     console.log(`!editableP.innerText  ALMOST empty!: innerText.length = ${editableP.innerText.length}, rich_text_count: ${this.rich_text_count}`)
                            // editableP.contentEditable = false

                        // }
                        // if(editableP.lastChild){
                        //     if(editableP.lastChild.nodeValue == null){
                                // console.log(`RICH_TEXT_COUNT: ${ this.rich_text_count }, INNER_TEXT_COUNT: ${ editableP.innerText.length }`)
                                // e.preventDefault()
                            // }
                        // }else{
                        //     e.preventDefault()
                        // }


                        // var bb = editableP.innerText == undefined
                        // editableP.contentEditable = false
                        // console.log('text is: ' + editableP.innerText + ' and length is: '+ editableP.innerText.length + ' editableP.innerText is undefined?: ' + bb)
                    // }
                    // if(editableP.isContentEditable){ console.log('checkCharCount: P is ContentEditable') }
                    // if(!editableP){
                    //     console.log('editableP undefined: ')
                        // e.stopPropagation()
                    // }
                    // if(editableP.innerText.length === 1){
                    //     console.log('!editableP.innerText empty!')
                    //     editableP.contentEditable = false
                    //
                    // }



                    // editableP.contentEditable = false
                    // console.log('length is: ' + editableP.innerText)
                    // var editableP = document.querySelector('#richED').firstChild
                    // if(editableP.innerText === '') { alert('!editableP.innerText empty!') }
                    // if(editableP.innerText === '' || editableP.innerText.length === 0){
                    //     console.log('!editableP.innerText empty!')
                        // e.preventDefault()
                        // editableP.contentEditable = false

                        // if(editableP.innerText.length === 0){
                        //     console.log('editableP.innerText.length is: ' + editableP.innerText.length)
                        //     editableP.contentEditable = false
                        // }
                        // if(editableP.innerText === ''){
                        //     console.log('editableP.innerText.length is: ' + editableP.innerText.length)
                        //     editableP.contentEditable = false
                        // }
                        // if(editableP.hasChildNodes()){
                        //     console.log('YES it has Child Nodes!')
                            // editableP.style.pointerEvents = 'none';
                            // editableP.contentEditable = 'false';
                        // }
                        // if(editableP.innerText.length === 0){ editableP.contentEditable = false }
                    // }
                // }else if(this_vc.$refs.reditor.children.length === 2) {
                //     console.log('checkCharCount: two child in #richED')
                //
                // }

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
                    var resizedImage = document.querySelector('img.active_img')


                    this_vc.test_resizer_data.width =  resizeFromLeftSide ? `${width_old - (x_new - x_old)}px` : `${width_old + (x_new - x_old)}px`
                    resizedImage.style.width = `${parseInt(this_vc.test_resizer_data.width) + 1}px`

                    this_vc.test_resizer_data.height = `${parseInt(getComputedStyle(resizedImage).height) - 1}px`
                    this_vc.test_resizer_data.image.x1_old = `${x_new}px`
                    this_vc.test_resizer_data.image.x2_rt = `${parseInt(this_vc.test_resizer_data.left) + parseInt(this_vc.test_resizer_data.width)}px`
                }
            },
            saveAsPost: function(){
                // var RichED = document.querySelector('div[id="richED"]')
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
                var RichED = document.querySelector('div[id="richED"]')
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()
                // var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', tokenCSRF)

                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        // var canvas = document.getElementById("canvas"); // canvas init
                        // var ctx = canvas.getContext("2d"); // canvas getContext

                        var respText = JSON.parse(xhr.responseText)
                        var fileUrl = respText.file.url
                        document.execCommand('insertImage', false, fileUrl)
                        console.log(fileUrl)

                        // sharp('/uploads/attachment/file/304/c3cea700e2e67f293250fdba6d42471d.jpg').rotate().resize(200)

                        // var canvasTag = document.createElement('canvas')
                        // canvasTag.id = 'canvas_example'
                        // canvasTag.className = 'canvas_example'
                        // canvasTag.className += 'last_r_img'
                        // document.querySelector('p#w').appendChild(image)
                        // RichED.appendChild(canvasTag)

                        // var canvas = new fabric.Canvas('canvas_example');

                        // fabric.Image.fromURL('/uploads/attachment/file/304/c3cea700e2e67f293250fdba6d42471d.jpg', function(oImg) {
                            // scale image down, and flip it, before adding it onto canvas
                            // oImg.scale(0.5).set('flipX', true);
                            // canvas.add(oImg);
                        // });
                        // gm(fileUrl)
                        //     .resize(240, 240)
                        //     .noProfile()
                        //     .write('uploads/attachment/file/304/resizedimage.jpg', function (err) {
                        //         if
                        // (!err) console.log('done');
                        //     });
                        // var image = new Image('/uploads/attachment/file/304/c3cea700e2e67f293250fdba6d42471d.jpg')
                        // var image = document.querySelector(`img[src='${fileUrl}']`)
                        // image.className = 'active_img'
                        // var resizableImg = image.cloneNode(true)
                        // resizableImg.className += ' res_img'
                        // // resizableImg.style.draggable = false
                        // resizableImg.draggable = false
                        // // resizableImg
                        // resizableImg.onclick = function(e){
                        //     console.log('resizable image is clicked')
                        //     // resizableImg.style.width = `${e.target.width - 100}px`
                        // }
                        //
                        // resizableImg.onmousedown = function(e){
                        //
                        //     this_vc.activateImageResizer()
                        //
                        //     console.log(` coordinates x, y: ${this_vc.cursor.position.x}, ${this_vc.cursor.position.y}`)
                        //     e.target.onmousemove = function(e){
                        //         console.log(` moved!!`)
                        //     }
                        // }
                        //
                        // resizableImg.onmousemove = function(e){
                        //     console.log(` moved!!`)
                        // }
                        //
                        // var resrg = document.querySelector('p.image_is_here')
                        // resrg.appendChild(resizableImg)

                            // alert(image.width + 'x' + image.height);
                            // console.log(`sizes: ${image}`)
                            // this.active_image.he = image.height
                            // this.active_image.wi = image.width
                        // console.log(`sizes: ${image}`)
                        // this.active_image.height = image.height
                        // this.active_image.width = image.width
                        // im.readMetadata('uploads/attachment/file/304/c3cea700e2e67f293250fdba6d42471d.jpg', function(err, metadata){
                        //     if (err) throw err;
                        //     console.log('Shot at '+metadata.exif.dateTimeOriginal);
                        // })
                        // Jimp.read(fileUrl, function (err, image) {
                        //     if (err) throw err;
                        //     image.resize(256, 256)            // resize
                        //     image.write("uploads/attachments/file/304/image-so-small.jpg"); // save
                        // })


                        // try {
                        //     console.log('info is: ' + info("/uploads/attachment/file/304/c3cea700e2e67f293250fdba6d42471d.jpg").size)
                        //     console.log("I should not show");
                        // } catch (ImageMagickMissingError) {
                        //     console.log("I should show");
                        // }
                        // console.log('width: ' + image.naturalHeight)

                        // console.log('naturaltheight:' + image.naturalWidth)
                        // var canvasTag = document.createElement('canvas')
                        // canvasTag.className = 'canvas_example'
                        // canvasTag.className += 'last_r_img'
                        // document.querySelector('p#w').appendChild(image)
                        // RichED.appendChild(canvasTag)
                        // RichED.lastChild.appendChild(image)
                        // image.className += 'resizableImg'
                        // console.log(image)
                        // console.log('width: ' + image.clientHeight)
                        // console.log('height:' + image.clientWidth)
                        // $('.resrg').css('width', '100px', 'height', '100px')
                        // $('p.resizableImg').draggable()
                        // document.querySelector('.resrg').appendChild(image)

                        // var resu =  document.execCommand('enableObjectResizing', false, 'true')
                        // console.log(resu)
                        // richEditor.document.execCommand('insertImage', false, fileUrl)

                        // ctx.drawImage(image, 10, 10); // canvas drawImage
                    }
                }
                // var elementum = document.querySelector('p.last_r_img img')
                // console.log(elementum)
                // var image = document.querySelector(`img[src="${fileUrl}"]`)
                // console.log('width: ' + image.naturalHeight)
                // console.log('naturaltheight:' + image.naturalWidth)
                // var ptag = document.createElement('p')
                // ptag.className = 'resizableImg'
                // RichED.appendChild(ptag)
                // RichED.lastChild.appendChild(image)
                // image.className += 'resizableImg'
                // console.log(image)
                // console.log('width: ' + image.clientHeight)
                // console.log('height:' + image.clientWidth)


            },
            execCmd: function(command) {
                // var position = this.getCursorPosition()
                // console.log('execCmd calls and cursor pos = ' + position)
                // var tagnamestyle = document.getSelection().anchorNode.parentNode.tagName
                console.log('execCmd calls')
                document.execCommand(command, false, null)
            },
            anchorizeImg: function(){

            },
            tokenCSRF () { // make it variable
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
                // var pTagQuantity = document.querySelector('#richED').children.length
                var editableP
                var reditor = this_vc.$refs.reditor
                // var editableP = document.querySelector('#richED').firstChild

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
                console.log('TARGET WIDTH ' + e.target.naturalWidth + 'TARGET HEIGHT ' + e.target.naturalHeight)
                // this_vc.active_image.he = e.target.height
                // this_vc.active_image.wi = e.target.width
                var act_img = document.querySelector('p.image_is_here')
                act_img.style.width = `${e.target.width}px`
                act_img.style.height = `${e.target.height}px`
                console.log(`act_img.top: ${act_img.offsetTop}, act_img.left: ${act_img.offsetLeft}`)
                this_vc.test_resizer_data.top = `${act_img.offsetTop}px`
                this_vc.test_resizer_data.left = `${act_img.offsetLeft}px`
                this_vc.test_resizer_data.height = `${e.target.height - 1}px`
                this_vc.test_resizer_data.width = `${e.target.width - 1}px`
                this_vc.test_resizer_data.image.x1_lt = `${parseInt(this_vc.test_resizer_data.left, 10)}px`
                this_vc.test_resizer_data.image.x2_rt = `${parseInt(this_vc.test_resizer_data.left, 10) + parseInt(this_vc.test_resizer_data.width, 10)}px`
                // this.test_resizer_data.image.x3_lb = this.this.test_resizer_data.left
                // this.test_resizer_data.image.x4_rb = this.this.test_resizer_data.left
                // this.test_resizer_data.image.y1_lt = this.this.test_resizer_data.left
                // this.test_resizer_data.image.y2_rt = this.this.test_resizer_data.left
                // this.test_resizer_data.image.y3_lb = this.this.test_resizer_data.left
                // this.test_resizer_data.image.y4_rb = this.this.test_resizer_data.left
            },
            resize_motherfucker: function(e){

            },
            toggle_image_resizer_activity: function(e){
                console.log(`cursor_over_image_resizer: ${this_vc.cursor_over_image_resizer}`)
                console.log('e IS')
                console.dir(e)
                console.log('event.target')
                console.dir(e.target)
                console.log('event.currentTarget')
                console.dir(e.currentTarget)
                console.log('toggle_image_resizer_activity')
                console.log(imageResizer.style.display)
                console.log(imageResizer.display)
                console.log(imageResizer.hidden)
                console.log(getComputedStyle(imageResizer).display)
                console.log(`e.target.id= ${e.target.id}`)
                console.log(`imageResizer.classList.contains('its_active'): ${imageResizer.classList.contains('its_active')}`)

                if(e.target.classList.contains('active_img')){
                    console.log(`e.target.classList.contains('active_img'): ${e.target.classList.contains('active_img')}`)
                    imageResizer.classList.add('its_active')

                    // e.stopPropagation
                }else if(e.target.id === 'testresize' &&  imageResizer.classList.contains('its_active') && this_vc.cursor_over_image_resizer !== true && this_vc.mouseupped_on_image_resizer === false){
                    console.log(`e.target.id === 'testresize': ${e.target.id === 'testresize'},imageResizer.classList.contains('its_active'): ${imageResizer.classList.contains('its_active')} `)
                    imageResizer.classList.remove('its_active')
                }else {
                    console.log('last ELSE')
                    console.log(`e.target.id === 'testresize': ${e.target.id === 'testresize'},imageResizer.classList.contains('its_active'): ${imageResizer.classList.contains('its_active')} `)
                    if(!e.target.classList.contains('active_img')){
                        console.log(`e.target.classList.contains('active_img'): ${e.target.classList.contains('active_img')}`)
                        this_vc.mouseupped_on_image_resizer = false
                    }
                    // this_vc.mouseupped_on_image_resizer = false
                }


                // if(e.target.id === 'testresize' &&  imageResizer.classList.contains('its_active')){
                //     imageResizer.classList.remove('its_active')
                // }

                // if(e.target.id === 'image_resizer' && imageResizer.classList.contains('its_active')){
                //     console.log()
                //     imageResizer.classList.remove('its_active')
                // }else if(e.target.id === 'testresize' &&){
                //
                // }

                // if(document.querySelector('#image_resizer').classList.contains('its_active')){
                //     document.querySelector('#image_resizer').classList.remove('its_active')
                // }
            },
            activateImageResizer: function(){
                document.querySelector('#image_resizer').classList.add('its_active')
            },
            unactivate_image_resizer: function(e){
                console.log('target:')
                console.log(e.target)
                console.log('currentTarget')
                console.dir(e.currentTarget)
                console.log(`evaentPhase: ${e.eventPhase }`)
                if(document.querySelector('#image_resizer').classList.contains('its_active')){
                    document.querySelector('#image_resizer').classList.remove('its_active')
                }
            },
            prepare_for_resizing(fileUrl){
                var image = document.querySelector(`img[src='${fileUrl}']`)
                image.className = 'active_img'

                var resizableImg = image.cloneNode(true)
                resizableImg.className += ' res_img'
                resizableImg.draggable = false


                resizableImg.onmousedown = function(e){
                    this_vc.setImageAreaProps(e)
                    // this_vc.toggle_image_resizer_activity(e)
                    this_vc.activateImageResizer(e)
                }

                // resizableImg.addEventListener('onclick',)

                // resizableImg.onclick.capture = function(){
                //     toggle_active_image_resizer
                // }

                resizableImg.onmousemove = function(e){
                    // console.log(` moved!!`)
                }

                var resrg = document.querySelector('p.image_is_here')
                resrg.appendChild(resizableImg)
            },
            resize_image: function(e){
                this_vc.mouse_down_on_IRH = true
                this_vc.test_resizer_data.handler = e.target.classList[e.target.classList.length - 1]
                console.log('resize_image')
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

    .image_resizer{
        position: absolute;
        border: solid 1px #1e88e5;
        display: none;
        user-select: none;
        box-sizing: content-box;

        &.its_active{
            display: block
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

    /*.writer{*/
        /*margin: 0;*/
        /*padding-top: 16px;*/
        /*padding-left: 14px;*/
        /*z-index: 2;*/
        /**/
        /*opacity: 1;*/

        /*&:empty{*/
            /*background: #B00100;*/
            /*color: none;*/
            /*<!--z-index: -20;-->*/
            /*opacity: 0;*/
            /*background: none;*/

        /*}*/
        /*& + span {*/
            /**/
        /*}*/

        /*&:before{*/
            /**/
        /*}*/
    /**/
        /*&:after{*/
            /*content: 'Пиши здесь';*/
            /*display: block;*/
        /*}*/
    /*}*/

    /*.writer:empty + span {*/
        /*opacity: 1;*/
    /*}*/

    /*.writer + span {*/
        /*opacity: 0;*/
    /*}*/


    .placeholderSpan{
        /*width: 100%;*/
        /*height: 100%;*/
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
        height: 400px;
        min-height: 399px;
        width: 800px;
        overflow-x: hidden;
        overflow-y: auto;
        border: 0;
        box-shadow: 0 1px 3px rgba(0,0,0,0.12),0 1px 1px 1px rgba(0,0,0,0.16);
        background: white;
        outline: none;
        padding: 0px 16px 16px;
        /*z-index: 2;*/
        font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;

        & :only-child{
            margin: 0;
            padding-top: 16px;
            /*padding-left: 14px;*/
            z-index: 2;
            /*background: red;*/
        }

        & :only-child:after{
            content: '';
            position: absolute;
        }

        & :only-child:empty:after{
            content: 'ТАЙПХИР!';
            position: absolute;
            color: rgba(28, 28, 28, 0.45);
            /*top: 60px;*/
            /*<!--left: -15px;-->*/
        }

        /*.writer:before{*/
            /*content: 'u lala!'*/
        /*}*/
    }

    /*#richED {*/
    /**/
    /**/
    /*}*/

    .resizableImg{
        resize: both;
        overflow: hidden;
    }

    /*img{*/
        /*resize: both;*/
    /*}*/

    body{
        /*font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;*/
        /*overflow-x: hidden;*/

        /*margin: 0!important;*/
        /*padding: 0!important;*/
    }

    /*#richEditor{*/
        /*overflow-x: hidden;*/
        /*width: 500px;*/
        /*height: 500px;*/

        /*document{*/
            /*overflow-x: hidden;*/
        /*}*/

        /*body{*/
            /*overflow-x: hidden;*/
        /*}*/
    /*}*/

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
        margin: 16px 0 0;
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

    .canvas_example{
        border: 1px green;
    }

    .res_img{
        object-fit: contain;
    }

</style>
