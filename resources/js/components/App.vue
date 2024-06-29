<script setup>
import { ref } from "vue";

const steps = [
    "1 step: name",
    "2 step: age",
    "3 step: email",
    "4 step: result",
];

const step = ref(1);
const formData = ref({ name: "", age: 18, email: "@gmail.com" });
</script>

<template>
    <div class="page">
        <div class="content-wrapper">
            <div class="wizard-wrapper">
                <div>step: {{ step }}</div>
                <div>
                    <vue-wizard
                        :steps="steps"
                        :step="step"
                        class="wrapper"
                        orientation="horizontal"
                    />
                </div>
            </div>
            <div class="form-wrapper">
                <div class="item" v-if="step === 1">
                    <p>What is your name?</p>
                    <input type="text" v-model="formData.name" />
                </div>
                <div class="item" v-if="step === 2">
                    <p>What is your age?</p>
                    <input type="number" v-model="formData.age" />
                </div>
                <div class="item" v-if="step === 3">
                    <p>What is your email?</p>
                    <input type="email" v-model="formData.email" />
                </div>
                <div v-if="step === 4">
                    <p>RESULT</p>
                    <code class="result"> {{ formData }} </code>
                </div>
            </div>
            <div class="actions">
                <button @click="step--">back</button>
                <button @click="step++">next</button>
            </div>
        </div>
    </div>
</template>

<style scoped>
.page {
    display: flex;
    justify-content: center;
    align-items: center;
    background-color: #1f1e1c;
    color: white;
    height: 100dvh;
    widows: 100dvw;
}
.content-wrapper {
    display: flex;
    flex-direction: column;
    gap: 2rem;
    transition: all ease-in-out 0.3s;
}

.wizard-wrapper {
    display: flex;
    flex-direction: column;
    gap: 1rem;
    border: 1px solid lightgrey;
    border-radius: 8px;
    padding: 1rem;
}

.form-wrapper {
    display: flex;
    justify-content: center;
    align-items: center;
}

.form-wrapper .item input:not(input[type="radio"]),
.form-wrapper .item,
.form-wrapper {
    width: 100%;
}

.form-wrapper .item input,
.actions button {
    padding: 1rem 0.5rem;
}

.actions {
    display: flex;
    flex-direction: column;
    gap: 2rem;
}

.result {
    padding: 1rem;
    border-radius: 8px;
    background-color: lightgray;
    color: black;
}
</style>
