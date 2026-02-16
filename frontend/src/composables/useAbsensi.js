import { reactive, ref } from "vue";

export function useAbsensi() {
  const loading = ref(false);
  const submitLoading = ref(false);
  const error = ref(null);
  const successMessage = ref(null);
  const formData = reactive([]);
  const editingKeterangan = ref(null);
  const whatsappMessage = ref("");
  const isShareModalOpen = ref(false);

  const stats = reactive({
    hadir: 0,
    izin: 0,
    sakit: 0,
    alpa: 0,
    terlambat: 0,
    belum: 0,
  });

  const calculateStats = () => {
    stats.hadir = formData.filter((g) => g.status === "Hadir").length;
    stats.izin = formData.filter((g) => g.status === "Izin").length;
    stats.sakit = formData.filter((g) => g.status === "Sakit").length;
    stats.alpa = formData.filter((g) => g.status === "Alpa").length;
    stats.terlambat = formData.filter((g) => g.status === "Terlambat").length;
    stats.belum = formData.filter((g) => !g.status).length;
  };

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
    calculateStats,
  };
}
