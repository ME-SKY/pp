<template>
    <div id="mooo">
        <div id="editor-ya" class="edityab"></div>
        <!--<link rel="stylesheet" href="//cdnjs.cloudflare.com/ajax/libs/jodit/3.1.39/jodit.min.css">-->
        <!--<script src="//cdnjs.cloudflare.com/ajax/libs/jodit/3.1.39/jodit.min.js"></script>-->
        <textarea id="jeditor" name="editor"></textarea>
    </div>

</template>

<script>

//     import Quill from 'quill/core';
//
//     import { AlignClass, AlignStyle } from 'quill/formats/align';
//     import { DirectionAttribute, DirectionClass, DirectionStyle } from 'quill/formats/direction';
//     import { IndentClass as Indent } from 'quill/formats/indent';
//
//     import Blockquote from 'quill/formats/blockquote';
//     import Header from 'quill/formats/header';
//     import List, { ListItem } from 'quill/formats/list';
//
//     import { BackgroundClass, BackgroundStyle } from 'quill/formats/background';
//     import { ColorClass, ColorStyle } from 'quill/formats/color';
//     import { FontClass, FontStyle } from 'quill/formats/font';
//     import { SizeClass, SizeStyle } from 'quill/formats/size';
//
//     import Bold from 'quill/formats/bold';
//     import Italic from 'quill/formats/italic';
//     import Link from 'quill/formats/link';
//     import Script from 'quill/formats/script';
//     import Strike from 'quill/formats/strike';
//     import Underline from 'quill/formats/underline';
//
//     import Image from 'quill/formats/image';
//     import Video from 'quill/formats/video';
//
//     import CodeBlock, { Code as InlineCode } from 'quill/formats/code';
//
//     import Formula from 'quill/modules/formula';
//     import Syntax from 'quill/modules/syntax';
//     import Toolbar from 'quill/modules/toolbar';
//
//     import Icons from 'quill/ui/icons';
//     import Picker from 'quill/ui/picker';
//     import ColorPicker from 'quill/ui/color-picker';
//     import IconPicker from 'quill/ui/icon-picker';
//     import Tooltip from 'quill/ui/tooltip';
//
//     import BubbleTheme from 'quill/themes/bubble';
//     import SnowTheme from 'quill/themes/snow';

//    import Quill from 'quill/core';
//
//    import Toolbar from 'quill/modules/toolbar';
//    import Snow from 'quill/themes/snow';
//
//    import Bold from 'quill/formats/bold';
//    import Italic from 'quill/formats/italic';
//    import Header from 'quill/formats/header';
//    import Underline from 'quill/formats/underline';
//    import Icons from 'quill/ui/icons';
//    import 'quill/dist/quill.core.css'
//    import 'quill/dist/quill.snow.css'
//    import 'quill/dist/quill.bubble.css'
//     import FontAwesomeIcon from '@fortawesome/vue-fontawesome'
//     import faDropdown from '@fortawesome/fontawesome-free-solid/faCaretDown'
//     Icons['dropdown'] = faDropdown;

     import Jodit from 'jodit';
//     import 'jodit/build/jodit.min.css';


//    Quill.register({
//        'modules/toolbar': Toolbar,
//        'formats/bold': Bold,
//        'formats/italic': Italic,
//        'formats/header': Header,
//        'formats/underline': Underline,
//        'themes/bubble': BubbleTheme,
//        'themes/snow': SnowTheme,
//        'ui/icons': Icons,
//        'ui/picker': Picker,
//        'ui/icon-picker': IconPicker,
//        'ui/color-picker': ColorPicker,
//        'ui/tooltip': Tooltip
//    })




    export default {
        mounted: function () {
            console.log('piska')
            var editor = new Jodit('#jeditor',{
                enableDragAndDropFileToEditor: true,
                extraButtons: ["upload"],
                maxWidth: 500,
                maxHeight: 320,
                uploader: {
                    url: '/attachments/',
                    format: 'json',
                    filesVariableName: 'images',
                    headers: {
                        'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').getAttribute('content')
                    },
                    process: function (resp) {
                        console.log(resp.body)

                    },
                    defaultHandlerError: function(data, resp) {
                        console.log("data: " + data)
                        if (resp != undefined)
                            console.log("resp: " + resp)
                    }
                }
//
            });

//            editor.uploader.bind($('#uploaderbox'));
//            var editor = new Jodit("#jeditor", {
//                "allowResizeY": false,
//                "height": 150,
//                "width": 400,
//                "max-width": 500,
//                "max-height": 320,
//                toolbarButtonSize: "small",
//                fullsize: false
//            });
//            var editor = new Quill('#editor-ya', {
//                modules: {
//                    toolbar: true
//                },
//                theme: 'snow'
//            });
        }

    }
//    import Quill from 'quill/core';
//
//    import Toolbar from 'quill/modules/toolbar';
//    import Snow from 'quill/themes/snow';
//
//    import Bold from 'quill/formats/bold';
//    import Italic from 'quill/formats/italic';
//    import Header from 'quill/formats/header';
//
//
//    Quill.register({
//        'modules/toolbar': Toolbar,
//        'themes/snow': Snow,
//        'formats/bold': Bold,
//        'formats/italic': Italic,
//        'formats/header': Header
//    })
//    if (document.getElementById('#editor-ya').length > 0)
//            alert('editor-ya!')
//            console.log('editor-ya')
//    console.log('hmm')
//    var editor = new Quill('#editor-ya')


</script>

<style>
    @import '../../../node_modules/jodit/build/jodit.min.css';

</style>