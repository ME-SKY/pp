<template>
    <div class="editable_content">

        <div style="height: 1000px; width: 1000px; border: 1px solid red; position: relative;" @mousemove="saveCoordinates" id="testresize" >
            <div>
                x {{ cursor.client.x }}, y {{cursor.client.y}}
            </div>
            <vue-draggable-resizable :handles="['tr','br','bl','tl']" :w="400" :h="250"  :x="300" :y="50" v-on:resizing="onResize" :parent="true" class="resrg" :draggable="false">

            </vue-draggable-resizable>

        </div>

        <!--<div id="drdr" v-draggable style="height: 120px; width: 120px; background-color: red"></div>-->
        <!--<p id="drdr" v-draggable style="height: 120px; width: 120px; background-color: red" ></p>-->



        <!--<canvas id="canvas" width=350 height=350></canvas>-->

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

        <div id="richED"  @mouseup="seeStyleOnTools" v-on:keydown="changePSpan" @keydown.delete="checkCharCount" contenteditable="true" @mouseover="mouseOnEditor" @mouseout="mouseOffEditor" @click="makeAreaActive"  @keyup.delete="CEDtrue">

            <p class="writer"  ></p>
            <!--<span id="placeholder2" contenteditable="false">placeholder2</span>-->
            <!--<div class="heightone" contenteditable="true" @mouseover="mouseOnEditor" @mouseout="mouseOffEditor" @click="makeAreaActive">-->
                <!--<p id="wr0" class="writer"  @keyup.enter="createNewWriter">-->
                    <!--<br>-->
                <!--</p>-->
            <!--</div>-->

            <!--<span class="placeholderSpan" contenteditable="false" :class="{ hidden_span: hidePlaceholderSpan }">тайп хир</span>-->


            <!--<vue-draggable-resizable :handles="['tr','br','bl','tl']" :w="700" :h="700"  :x="50" :y="50" v-on:resizing="onResize" :parent="true" class="resrg" :draggable="false">-->

            <!--</vue-draggable-resizable>-->
            <!--<canvas></canvas>-->
            <!--<p class="last_p"></p>-->
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
    // import 'jquery-ui'
    // import { Draggable } from 'draggable-vue-directive'
    import faImage from '@fortawesome/fontawesome-free-solid/faImage'
    import faSave from '@fortawesome/fontawesome-free-solid/faSave'
    import faBold from '@fortawesome/fontawesome-free-solid/faBold'
    import faItalic from '@fortawesome/fontawesome-free-solid/faItalic'



    var tag_names = ['b', 'i']
    var insertedNodes = [];


    export default {
        data: function(){
          return {
              mouse_on_editor: false,
              hidePlaceholderSpan: false,
              rich_text: '',
              width: 0,
              height: 0,
              x: 10,
              y: 10,
              cursor:{
                  client: { x: 0, y: 0 }
              },
              buttons_activity: {
                  b_active: false,
                  i_active: false
              },

          }
        },
        // directives: {
        //   Draggable
        // },
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

            // richED () {}


        },
        mounted: function(){
            document.execCommand("defaultParagraphSeparator", false, "p")

            // var observer = new MutationObserver(function(mutations) {
            //     mutations.forEach(function(mutation) {
            //         for (var i = 0; i < mutation.addedNodes.length; i++)
            //             insertedNodes.push(mutation.addedNodes[i]);
            //     })
            // });
            // observer.observe(document, { childList: true });
            // console.log(insertedNodes);



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
        },
        methods: {


            deleteBr: function(){
                console.log('delete br')

            },
            checkCharCount: function(){
                console.log('check char count')
                var editableP = document.querySelector('#richED').firstChild

                if(editableP.innerText.length <= 1){
                    console.log('YES length is 1 or less')
                    if(editableP.hasChildNodes()){
                        console.log('YES it has Child Nodes!')
                        // editableP.style.pointerEvents = 'none';
                        editableP.contentEditable = 'false';
                    }

                }

            },
            CEDtrue: function(){
                console.log('CEDtrue')
                var editableP = document.querySelector('#richED').firstChild
                if(editableP.isContentEditable == false){
                    editableP.contentEditable = true;
                    if(editableP.innerText.length <= 1){
                        editableP.innerText = ''
                    }
                }
            },
            makeAreaActive: function(){
                console.log('makeAreaActive')
                var docArea = document.querySelector('#richED').firstChild
                var pTagQuantity = document.querySelector('#richED').children.length
                console.log(docArea)
                if(this.mouse_on_editor && pTagQuantity === 1){
                    console.log(this.mouse_on_editor)
                    // this.$emit('focus')
                    docArea.focus()
                }
            },
            mouseOnEditor: function(){
                console.log('mouse on editor')
                this.mouse_on_editor = true
            },
            mouseOffEditor: function(){
                console.log('mouse off editor')
                this.mouse_on_editor = false
            },
            changePSpan: function(e){
                console.log('changeSpan and event is ' + e)
                // console.log(e.target)
                this.hidePlaceholderSpan = this.charCounterChecker(e.target)
            },

            charCounterChecker: function(target){
                // if(target.innerText.length == 1){
                //     target.innerHTML += '&#8203;'
                // }
                console.log('target: ' + target)
                // console.log(target.innerText.length)
                return target.innerText.length > 0
            },
            // changePlaceholderSpanVisibility: function(vision){
            //     this.showPlaceholderSpan = vision
            //
            //     vision ? (
            //         this.showPlaceholderSpan = true
            //     ) : (
            //
            //     )


            cleanInner: function(e){
                console.log('cleanInner')
                console.log(e.target.innerText)

                if(e.target.innerText == 'оу это кажется текст?! а?? мм????'){ e.target.innerHTML = '&#8203;Пишите сюда' }
            },
            invisiblePPH: function(e){
                https://bitcoin.org/en/you-need-to-knowconsole.log('invisiblePPH')
                e.target.style.display = 'none'
            },
            visiblePPH: function(e){
                console.log("length: " + document.querySelector('div[id="richED"]').querySelectorAll('p').length)
                if(document.querySelector('div[id="richED"]').querySelectorAll('p').length <= 2){
                    e.target.style.dislay = 'block'
                }
            },
            saveCoordinates: function(e){
                var testResizeDiv = document.getElementById('testresize');
                this.cursor.client.x = e.clientX - testResizeDiv.offsetLeft
                this.cursor.client.y = e.clientY - testResizeDiv.offsetTop
                // return("x = " + e.clientX + ", y = " + e.clientY)
            },
            onResize: function (x, y, width, height) {
                this.x = x
                this.y = y
                this.width = width/height
                this.height = height/width
            },
            onDrag: function (x, y) {
                this.x = x
                this.y = y
            },
            saveAsPost: function(){
                var RichED = document.querySelector('div[id="richED"]')
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
                var RichED = document.querySelector('div[id="richED"]')
                var vc = this
                var formData = new FormData(document.forms.attachment);
                var xhr = new XMLHttpRequest()
                // var token = document.querySelector('meta[name="csrf-token"]').getAttribute('content')

                xhr.open("POST", "/attachments/")
                xhr.setRequestHeader('X-CSRF-Token', this.tokenCSRF())

                xhr.send(formData)
                xhr.onreadystatechange = function(){
                    if (xhr.readyState == 4) {
                        // var canvas = document.getElementById("canvas"); // canvas init
                        // var ctx = canvas.getContext("2d"); // canvas getContext

                        var respText = JSON.parse(xhr.responseText)
                        var fileUrl = respText.file.url
                        document.execCommand('insertImage', false, fileUrl)
                        var image = document.querySelector(`img[src="${fileUrl}"]`)
                        console.log('width: ' + image.naturalHeight)

                        console.log('naturaltheight:' + image.naturalWidth)
                        // var ptag = document.createElement('p')
                        // ptag.className = 'resizableImg'
                        // ptag.className += 'last_r_img'
                        document.querySelector('p.last_p').appendChild(image)
                        // RichED.appendChild(ptag)
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
                var elementum = document.querySelector('p.last_r_img img')
                console.log(elementum)
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
                // var pTagQuantity = document.querySelector('#richED').children.length
                var editableP = document.querySelector('#richED').firstChild
                // if(pTagQuantity <= 1){
                    if(!editableP.hasChildNodes()){
                        // var editableP = document.querySelector('#richED').firstChild
                        if(editableP.innerText.length <= 1){

                        }
                    }
                // }
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
                // console.log('NOT IN WHILE, i is: ' + i.tagName)

                while(i.tagName != 'DIV' && i.tagName!= undefined){
                    node_names.push(i.tagName.toLowerCase())
                    i = i.parentNode
                }
                return node_names
            }

        }
    }
</script>


<style lang="scss" scoped>

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
        padding: 16px;
        /*z-index: 2;*/
        font-family: 'Source Sans Pro', 'Helvetica Neue', Helvetica, Arial, sans-serif;

        & :only-child{
            margin: 0;
            padding-top: 16px;
            padding-left: 14px;
            z-index: 2;
            /*background: red;*/
        }

        & :only-child:after{
            content: 'CHLEN';
            position: absolute;
        }

        & :only-child:empty:after{
            content: '!!!!!!!!';
            position: absolute;
            top: 60px;
            left: -15px;
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
