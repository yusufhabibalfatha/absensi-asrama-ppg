<template>
  <div
    class="fixed inset-0 bg-black bg-opacity-50 flex justify-center items-center z-50 p-4"
  >
    <div class="bg-white rounded p-4 w-full max-w-lg">
      <h3 class="font-bold mb-2">📤 Preview Pesan WhatsApp</h3>
      <textarea
        class="w-full border p-2 rounded mb-4"
        :value="message"
        readonly
        rows="10"
      ></textarea>
      <div class="flex gap-2 justify-end flex-wrap">
        <button
          class="bg-purple-600 text-white px-3 py-1 rounded"
          @click="copyText"
        >
          📋 Salin Teks
        </button>
        <button
          class="bg-green-600 text-white px-3 py-1 rounded"
          @click="sendWA"
        >
          📤 Kirim ke WhatsApp
        </button>
        <button
          class="bg-gray-500 text-white px-3 py-1 rounded"
          @click="$emit('close')"
        >
          ✖ Tutup
        </button>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: ["message"],
  emits: ["close"],
  setup(props) {
    const copyText = async () => {
      try {
        await navigator.clipboard.writeText(props.message);
        alert("✅ Teks berhasil disalin");
      } catch {
        alert("❌ Gagal menyalin teks");
      }
    };

    const sendWA = () => {
      const url = `https://api.whatsapp.com/send?text=${encodeURIComponent(props.message)}`;
      window.open(url, "_blank");
    };

    return { copyText, sendWA };
  },
};
</script>
