<template>
  <div class="w-full max-w-3xl mx-auto py-8">
    <h5 class="text-center mt-2">작업등록</h5>
    <hr />
    <div class="CARD bg-primary w-50 border"></div>
    <div v-if="isLoading">
      <!-- Show loading indicator -->
      <p>Loading...</p>
    </div>
    <div v-else class="container chart_container"></div>

    <div class="album py-5 bg-body-tertiary">
      <div class="container"></div>
    </div>
    <div class="container">
      <!--  -->
      <form class="">
        <div class="d-flex justify-content-between"></div>
        <hr />
        <div class="d-flex flex-wrap">
          <!-- {{ product }} -->
          {{ selectedProduct }}
          {{ selectedProduct?.PRODUCT_NO }}

          <div class="col-3">
            <label for="validationDefault01">날짜</label>
            <input
              v-model="form.CREATE_DATE"
              type="DATE"
              class="form-control border border-success"
              id="validationDefault01"
              placeholder="DATE"
              required
            />
          </div>
          <div class="col-3 col-md-3">
            <label for="validationDefault01">품명</label>

            <select
              v-model="form.PD_NAME"
              class="form-control border border-success"
              id="validationDefault02"
              required
            >
              <option isabled value="">품명</option>
              <option
                v-for="(parduct_name, index) in product"
                :key="index"
                :value="parduct_name.PD_NAME"
              >
                {{ parduct_name.PD_NAME }}
              </option>
            </select>
          </div>

          <div class="col-3 col-lg-2">
            <label for="validationDefault01">품명</label>
            <input
              v-model="form.PRODUCT"
              type="text"
              class="form-control border border-success"
              id="validationDefault01"
              placeholder=""
              required
            />
          </div>

          <div class="col-3 col-lg-2">
            <label for="validationDefault01">COUNT</label>
            <input
              v-model="form.COUNT"
              type="text"
              class="form-control border border-success"
              id="validationDefault01"
              placeholder="COUNT"
              required
            />
          </div>

          <!--  -->
          <div class="col-2 col-lg-2">
            <label for="validationDefault01">등록자</label>
            <input
              v-model="form.REG_ACCOUNT"
              type="text"
              class="form-control border border-success"
              id="validationDefault01"
              placeholder="등록자"
              required
            />
          </div>

          <div class="d-flex"></div>

          <!--  -->
          <div class="d-flex d-flex-wrap"></div>
        </div>
        <div class="d-flex"></div>
      </form>
      <!--  -->
      <div class="d-flex mt-1 w-100 justify-content-center">
        <button
          @click="insertData"
          class="btn btn-warning btn-sm w-50 text-white mt-2"
          type="submit"
        >
          INSERT
        </button>
      </div>
    </div>

    <hr />
    <div class="container">
      <p class="text-end me-4">최근데이터 10개</p>
      <div class="table-responsive">
        <table class="table table-sm text-center">
          <thead>
            <tr>
              <!-- <th>DATE</th> -->
              <th>DATE</th>
              <th>품명</th>
              <th>품명</th>

              <th>COUNT</th>

              <th class="d-none d-md-table-cell">등록자</th>

              <th>
                <div
                  class="btn btn-sm btn-success sm-btn"
                  @click="exportToExcel"
                >
                  <svg
                    width="24px"
                    height="14px"
                    viewBox="0 0 24 24"
                    xmlns="http://www.w3.org/2000/svg"
                  >
                    <g>
                      <path fill="white" d="M0 0h24v24H0z" />
                      <path
                        d="M2.859 2.877l12.57-1.795a.5.5 0 0 1 .571.495v20.846a.5.5 0 0 1-.57.495L2.858 21.123a1 1 0 0 1-.859-.99V3.867a1 1 0 0 1 .859-.99zM4 4.735v14.53l10 1.429V3.306L4 4.735zM17 19h3V5h-3V3h4a1 1 0 0 1 1 1v16a1 1 0 0 1-1 1h-4v-2zm-6.8-7l2.8 4h-2.4L9 13.714 7.4 16H5l2.8-4L5 8h2.4L9 10.286 10.6 8H13l-2.8 4z"
                      />
                    </g>
                  </svg>
                </div>
              </th>
            </tr>
          </thead>
          <tbody>
            <tr v-for="(item, index) in workOrderList" :key="index">
              <!-- <td>{{item.NO }}</td> -->
              <td>{{ formatDateToMonthDay(item.CREATE_DATE) }}</td>
              <td>{{ item.PRODUCT }}</td>
              <td>{{ item.PD_NAME }}</td>

              <td>{{ item.COUNT }}</td>

              <td class="d-none d-md-table-cell">{{ item.REG_ACCOUNT }}</td>

              <td>
                <div class="btn btn-sm btn-danger" @click="onRegister(item)">
                  REGISTER
                </div>
              </td>
            </tr>
          </tbody>
        </table>
      </div>
    </div>

    <hr />
  </div>
</template>

<script setup lang="ts">
import BarCharts from "~/compoments/BarCharts.vue";
import type { WorkOrderModel } from "~~/server/model/workOrder";
import type { ProductModel } from "~~/server/model/product";
import { formatDateToMonthDay } from "~~/utils/formatDatetoMonth";
import { useRoute } from "vue-router";
import { useWorkStore } from "~/store/works";
import * as XLSX from "xlsx";
useHead({
  title: "List Page",
});
const router = useRouter();
const form = reactive({
  CREATE_DATE: "",
  PRODUCT: "",
  PD_NAME: "",
  COUNT: "",
  REG_ACCOUNT: "",
});

const product = ref<ProductModel[]>([]);
const workOrderList = ref<WorkOrderModel[]>([]);

const isLoading = ref(true);

const fetchData = async () => {
  try {
    const result = await $fetch("/api/workOrder/getRecord");

    workOrderList.value = result.data as WorkOrderModel[];
    const productData = await $fetch("/api/product/getProduct");
    product.value = productData.data as ProductModel[];

    isLoading.value = false; // Set loading state to false when data is fetched
  } catch {
    alert("Fetch error");
  }
};

const insertData = async () => {
  // 입력값 검증을 위한 플래그 설정
  let isValid = true;
  let alertMessage = "";

  // 각 입력 필드에 대한 검증
  if (!form.CREATE_DATE.trim()) {
    isValid = false;
    alertMessage += "DATE를 입력해주세요.\n";
  }
  if (!form.PD_NAME.trim()) {
    isValid = false;
    alertMessage += "PRODUCT 를 입력해주세요.\n";
  }

  const countNumber = Number(form.COUNT);
  if (!form.COUNT || isNaN(countNumber) || countNumber <= 0) {
    isValid = false;
    alertMessage += "수량 을 입력해주세요.\n";
  }

  if (!form.REG_ACCOUNT.trim()) {
    isValid = false;
    alertMessage += "등록자를 를 입력해주세요.\n";
  }

  try {
    await $fetch("/api/workOrder", {
      method: "POST",
      body: form,
    });
    alert("등록되었습니다.");
    await fetchData();
    // router.push('/blog');
  } catch {
    alert("RECORD error");
  }
};

const onRegister = async (item: any) => {
  const store = useWorkStore();
  store.addItem(item);
  const ID = selectedProduct.PRODUCT_NO;
  // router.push("/jaedan/register");
  router.push({ path: "/jaedan/register", query: { param: ID } });

  // store.addItem(item);
};
const productName = ref([
  // Populate product data
  { PD_NAME: "CAB TAP", NO: "1" },
  { PD_NAME: "SAB 테더", NO: "2" },
  // Other product items
]);
const selectedProduct = computed(() => {
  return product.value.find((item) => item.PD_NAME === form.PD_NAME);
});

// Watch for changes in the selected PD_NAME and update the PRODUCT value
watch(
  () => form.PD_NAME,
  (newValue) => {
    const selected = product.value.find((item) => item.PD_NAME === newValue);
    form.PRODUCT = selected ? selected.PRODUCT_NO : "";
  },
);

onMounted(fetchData);

const resetForm = () => {
  form.PRODUCT = "";
  form.CREATE_DATE = "";

  form.COUNT = "";
  // form.COUNT= 0 as any;
  form.REG_ACCOUNT = "";
};
// const insertData = () => {
//   data.value.push({ ...form });
//   resetForm();
// };

// excel 데이터 받기
const exportToExcel = () => {
  const data = workOrderList.value; // Assuming getInsertData contains the table data

  const ws = XLSX.utils.json_to_sheet(data);
  const wb = XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb, ws, "Sheet1");

  const wbout = XLSX.write(wb, { bookType: "xlsx", type: "array" });
  const blob = new Blob([wbout], { type: "application/octet-stream" });

  const fileName = "table_data.xlsx";
  const url = URL.createObjectURL(blob);

  const a = document.createElement("a");
  a.href = url;
  a.download = fileName;
  a.click();

  URL.revokeObjectURL(url);
};
</script>
<style scoped>
label {
  padding-left: 10%;
  font-size: small;
  border-bottom: 1px solid rgb(182, 67, 67);
  width: 100%;
  margin-bottom: 5px;
}
.col,
.col-1,
.col-2,
.col-4 {
  margin-right: 5px;
  text-align: center;
}
.form-control::placeholder {
  font-size: 12px; /* 원하는 글자 크기로 조정 */
}
@media (max-width: 720.98px) {
  .table-sm td {
    font-size: 0.7rem; /* A
      /* font-size:.2em; 예시로 14px로 설정 */
  }
}
td {
  font-weight: 300;
}
@media (max-width: 720.98px) {
  .table-sm th {
    font-size: 0.7rem; /* A
      /* font-size:.2em; 예시로 14px로 설정 */
  }
}
th {
  font-weight: 500;
  background-color: rgb(247, 226, 226);
}
.table-sm .btn {
  font-size: 0.7rem;
}
select {
  -webkit-appearance: none;
  -moz-appearance: none;
  appearance: none;
  background-image: url('data:image/svg+xml;utf8,<svg fill="black" height="24" viewBox="0 0 24 24" width="24" xmlns="http://www.w3.org/2000/svg"><path d="M7 10l5 5 5-5z"/><path d="M0 0h24v24H0z" fill="none"/></svg>');
  background-repeat: no-repeat;
  background-position: right center;
  padding-right: 1.5em; /* Adjust as needed */
  font-size: 0.8rem;
}
input {
  font-size: 0.8rem;
}
</style>
