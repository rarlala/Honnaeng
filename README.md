# 냉장고 재료 관리 앱
2024.03.15 ~ 2024.04.15 | 개인 프로젝트
유저가 냉장고를 추가하고 각 냉장고별 재료 및 유통기한 관리를 할 수 있는 앱

<br />

## 사용한 기술 스택
UI : `Code based UI` `Collection View` `Diffable DataSource`

아키텍처 : `MVVM` 

네트워킹 : `URLSession` 

데이터 관리 : `CoreData` `FileManager` 

미디어 접근 및 처리 : `UIImagePickerController` `AVCaptureSession` 

<br />

## 대표적인 구현 화면
| **재료 리스트 화면** | **재료 추가 화면** |
|:-----------------------------------------------------:|:-----------------------------------------------------:|
| ![재료 리스트 화면](https://file.notion.so/f/f/72300c4e-dbcf-4962-8496-36c9bcdb8c50/41b08716-6a7a-4c3e-b295-0601e84f0268/IMG_7882.png?table=block&id=770c3830-3721-4dfa-bf12-c1e198c391bf&spaceId=72300c4e-dbcf-4962-8496-36c9bcdb8c50&expirationTimestamp=1726250400000&signature=d3jHrxNWusfOxbKJWRu0eIOa-ARM_lajp3SPeVufF40&downloadName=IMG_7882.PNG.png) | ![재료 추가 화면](https://file.notion.so/f/f/72300c4e-dbcf-4962-8496-36c9bcdb8c50/f96ffaee-3258-401e-a1fb-f2f5b01973db/IMG_7885.png?table=block&id=fe22e67c-e20e-4cb5-a792-d8c4b05136c4&spaceId=72300c4e-dbcf-4962-8496-36c9bcdb8c50&expirationTimestamp=1726250400000&signature=PEGPtU7WKF1eICqytKoOGT2f2HH1tC-l6WXtcHZKG28&downloadName=IMG_7885.PNG.png) |

| **바코드로 입력 화면** | **냉장고 관리 화면** |
|:-----------------------------------------------------:|:-----------------------------------------------------:|
| ![바코드로 입력 화면](https://file.notion.so/f/f/72300c4e-dbcf-4962-8496-36c9bcdb8c50/581c0fab-2c0e-42b9-8231-581c41334832/IMG_7884.png?table=block&id=2f528846-2ea5-4537-a68c-89f50d9ec0a9&spaceId=72300c4e-dbcf-4962-8496-36c9bcdb8c50&expirationTimestamp=1726250400000&signature=EQYsq-2GygKbImuD4eCVTnSBPOoOc0shUn4Dxd9I8o0&downloadName=IMG_7884.PNG.png) | ![냉장고 관리 화면](https://file.notion.so/f/f/72300c4e-dbcf-4962-8496-36c9bcdb8c50/4b1f029c-e8f6-4176-b23e-3c07c57d31e0/IMG_7881.png?table=block&id=abd0c2a9-2b34-48cc-9315-70f129b02633&spaceId=72300c4e-dbcf-4962-8496-36c9bcdb8c50&expirationTimestamp=1726250400000&signature=NFon9ysFfHF5jEgMygjSk-SL3Z0UjSKCKOwKmJJLp38&downloadName=IMG_7881.PNG.png) |

<br />

## 대표적인 구현 내용

- 데이터 관리: `CoreData`를 활용하여 냉장고 및 재료 정보를 관리하는 데이터베이스를 구축하였습니다. 복잡한 데이터 구조를 효율적으로 관리하고, 사용자가 재료를 쉽게 저장, 탐색, 수정할 수 있는 기능을 구현했습니다. CoreData를 활용해 앱을 종료한 후에도고 사용자의 데이터가 남아있도록 구현했습니다.
- 사진 추가 및 관리 기능: `UIImagePickerController` 및 `FileManager`를 활용하여 사용자가 재료 사진을 추가하고 관리할 수 있는 기능을 구현했습니다.
- 바코드 스캔 기능: `AVCaptureSession`과 `식품의약품안전체 제공 식품 바코드 정보 API`를 결합하여 식품 바코드를 스캔하고 해당 식품 정보를 자동으로 검색, 표시하는 기능을 개발했습니다. 해당 기능을 통해 사용자가 직접 재료명을 입력하지 않아도 자동으로 입력되어 유저 편의성을 높였습니다.
- 재료 검색 및 필터링 기능: 재료별 특성을 고려한 필터 처리 및 재료명 검색 기능을 구현하여, 사용자가 원하는 재료를 빠르게 찾을 수 있도록 했습니다.
- 기술적 접근 및 UI 설계: `MVVM 패턴`을 적용하여 앱의 구조를 설계하고, `Code based UI` 접근 방식을 사용하여 `Collection View`와 `Diffable DataSource`를 통해 동적이고 반응성 높은 사용자 인터페이스를 구현했습니다. 공공 API 키의 보안을 위해 `.xcconfig`와 `.gitignore` 를 사용해 구현했습니다.
