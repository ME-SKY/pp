<template>
    <textarea name="content" id="editor" :value="value"
              v-on:input="updateValue($event.target.value)" >
    </textarea>
</template>

<script>
    import ClassicEditor from '@ckeditor/ckeditor5-build-classic';

    export default {
        data: function () {
            return {
                instance: null
            }
        },
        props: ['value'],
        mounted(){
            ClassicEditor
                    .create( this.$el, {
                        toolbar: [ 'bold', 'italic', 'link', 'imageUpload'],
                        ckfinder: {
                            uploadUrl: '/attachments/'
                        }
                    } )
                    .then( editor => {
                this.instance = editor;
        } )
        .catch( error => {
                console.error( error );
        } );
        },
        updated(){
            this.instance.setData(this.value)
        },
        methods: {
            updateValue: function (value) {
                this.$emit('input', value)
            }
        },
        watch: {
            value: function(){
                let html = this.instance.getData();
                if(html != this.value){
                    this.instance.setData(this.value)
                }
            }
        }
    }
</script>

<style>

</style>
