<template>
    <div class="editable_content">
        <iframe name="richEditor" id="richEditor">

        </iframe>
    </div>
</template>

<script>




    export default {
        mounted: function(){
            richEditor.document.designMode = 'on'
        }
    }
</script>


<style lang="scss" scoped>
    #richEditor{
        width: 500px;
        height: 500px;
    }
</style>