<template>
  <div class="p-6">
    <h1 class="text-2xl font-bold text-center mb-6">
      Absensi Kelompok {{ kelompokNama }}
    </h1>

    <TambahGenerusForm
      :kelompokId="kelompokId"
      @generus-added="handleGenerusAdded"
    />

    <AbsensiStatistic :stats="stats" />

    <div v-if="formData.length === 0 && !loading" class="text-center mt-6">
      📭 Tidak ada data generus
    </div>

    <div v-for="generus in formData" :key="generus.id">
      <GenerusCard
        :generus="generus"
        @update-status="updateStatus"
        @edit-keterangan="openKeterangan"
        @cancel-status="cancelStatus"
      />
    </div>

    <div class="mt-6 text-center">
      <button
        class="bg-blue-600 text-white px-4 py-2 rounded shadow"
        @click="submitAbsensi"
        :disabled="submitLoading || formData.length === 0"
      >
        {{ submitLoading ? "💾 Menyimpan..." : "📤 Bagikan ke WhatsApp" }}
      </button>
    </div>

    <WhatsAppPreview
      v-if="isShareModalOpen"
      :message="whatsappMessage"
      @close="isShareModalOpen = false"
    />

    <KeteranganModal
      v-if="editingKeterangan"
      :status="editingKeterangan.status"
      :currentKeterangan="editingKeterangan.keterangan"
      @save="saveKeterangan"
      @close="editingKeterangan = null"
    />
  </div>
</template>

<script>
import { ref, onMounted } from "vue";
import { useAbsensi } from "../composables/useAbsensi";
import GenerusCard from "../components/GenerusCard.vue";
import KeteranganModal from "../components/KeteranganModal.vue";
import TambahGenerusForm from "../components/TambahGenerusForm.vue";
import WhatsAppPreview from "../components/WhatsAppPreview.vue";
import AbsensiStatistic from "../components/AbsensiStatistic.vue";

export default {
  components: {
    GenerusCard,
    KeteranganModal,
    TambahGenerusForm,
    WhatsAppPreview,
    AbsensiStatistic,
  },
  props: ["kelompokId", "kelompokNama"],
  setup(props) {
    const {
      loading,
      submitLoading,
      error,
      successMessage,
      formData,
      editingKeterangan,
      whatsappMessage,
      isShareModalOpen,
      stats,
      calculateStats,
    } = useAbsensi();

    const fetchGenerus = async () => {
      loading.value = true;
      const API_URL = import.meta.env.VITE_API_URL || "http://localhost/api";

      try {
        const res = await fetch(
          `${API_URL}/api/generus?kelompok_id=${props.kelompokId}`,
        );
        const data = await res.json();
        if (data.status) {
          formData.splice(
            0,
            formData.length,
            ...data.data.map((g) => ({ ...g, status: null, keterangan: null })),
          );
          calculateStats();
        }
      } catch (err) {
        console.error(err);
      } finally {
        loading.value = false;
      }
    };

    const updateStatus = (id, status) => {
      const g = formData.find((g) => g.id === id);
      if (g) g.status = status;
      calculateStats();
    };

    const cancelStatus = (id) => {
      const g = formData.find((g) => g.id === id);
      if (g) g.status = null;
      calculateStats();
    };

    const openKeterangan = (id, status, keterangan) => {
      editingKeterangan.value = { id, status, keterangan };
    };

    const saveKeterangan = (newKeterangan) => {
      const g = formData.find((g) => g.id === editingKeterangan.value.id);
      if (g) g.keterangan = newKeterangan;
      editingKeterangan.value = null;
    };

    const handleGenerusAdded = (newGenerus) => {
      formData.push({ ...newGenerus, status: null, keterangan: null });
      calculateStats();
    };

    const submitAbsensi = async () => {
      submitLoading.value = true;
      const API_URL = import.meta.env.VITE_API_URL || "http://localhost/api";

      try {
        const res = await fetch(`${API_URL}/api/absensi`, {
          method: "POST",
          headers: { "Content-Type": "application/json" },
          body: JSON.stringify({ data: formData }),
        });
        const data = await res.json();
        if (data.status) {
          // generate WA message di frontend
          whatsappMessage.value = data.message || "Absensi berhasil!";
          isShareModalOpen.value = true;
        }
      } catch (err) {
        console.error(err);
      } finally {
        submitLoading.value = false;
      }
    };

    onMounted(fetchGenerus);

    return {
      loading,
      submitLoading,
      error,
      successMessage,
      formData,
      editingKeterangan,
      whatsappMessage,
      isShareModalOpen,
      stats,
      updateStatus,
      cancelStatus,
      openKeterangan,
      saveKeterangan,
      handleGenerusAdded,
      submitAbsensi,
    };
  },
};
</script>

<style scoped>
/* Tambahkan styling Tailwind sesuai kebutuhan */
</style>
