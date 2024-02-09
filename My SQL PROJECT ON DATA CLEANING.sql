--Cleaning Data in SQL
SELECT*
FROM NHouisng

--Standardising DATE FORMAT
SELECT SaleDate
FROM NHouisng

SELECT SaleDate,CONVERT(Date,Saledate)
FROM NHouisng

Update NHouisng
SET SaleDate = CONVERT(Date,Saledate)

ALTER TABLE NHouisng
Add SaleDateConverted Date;

Update NHouisng
SET SaleDateconverted = CONVERT(Date,Saledate)

SELECT SaleDateConverted
FROM NHouisng

--PROPERTY ADDRESS

SELECT *
FROM NHouisng
---WHERE PROPERTYADDRESS IS NULL
Order by parcelID

SELECT a.ParcelID, a.PropertyAddress,b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress) AS Newpropertyaddress
FROM NHouisng a
JOIN NHouisng b ON a.ParcelID = b.ParcelID AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

UPdate a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress) 
FROM NHouisng a
JOIN NHouisng b ON a.ParcelID = b.ParcelID AND a.[UniqueID ]<> b.[UniqueID ]
WHERE a.PropertyAddress is null

---Breaking address into individual columns 

SELECT PropertyAddress
FROM NHouisng
---WHERE PROPERTYADDRESS IS NULL
--Order by parcelID

SELECT 
SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1) AS Address
,SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))AS Address 
From NHouisng

ALTER TABLE NHouisng
Add PropertySplitAddress Nvarchar (255);

Update NHouisng
SET PropertySplitaddress = SUBSTRING (PropertyAddress, 1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NHouisng
Add PropertySplitCity Nvarchar(255);

Update NHouisng
SET PropertySplitCity = SUBSTRING (PropertyAddress, CHARINDEX(',',PropertyAddress)+1, len(PropertyAddress))

SELECT *
FROM NHouisng


--OR YOU CAN USE THIS SHORTWAY

SELECT *
FROM NHouisng

SELECT OwnerAddress
FROM NHouisng
---WHERE OwnerAddress IS NOT NULL

SELECT
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3),
PARSENAME(REPLACE(OwnerAddress, ',' , '.') ,2),
PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)

FROM NHouisng
WHERE OwnerAddress IS NOT NULL


ALTER TABLE NHouisng
Add OwnerSplitAddress Nvarchar (255);

Update NHouisng
SET OwnerSplitaddress = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 3)

ALTER TABLE NHouisng
Add OwnerSplitCity Nvarchar(255);

Update NHouisng
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 2)

ALTER TABLE NHouisng
Add OwnerSplitState Nvarchar (255);

Update NHouisng
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',' , '.'), 1)


SELECT *
FROM NHouisng
WHERE OwnerAddress IS NOT NULL

----CHANGE Y AND N AND NO "SOLD AS VACNT" FIELD

SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
From NHouisng
Group by SoldAsVacant
Order by 2

SELECT SoldAsVacant
, CASE when SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END
FROM NHouisng

UPdate NHouisng
SET SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'YES'
       WHEN SoldAsVacant = 'N' THEN 'NO'
	   ELSE SoldAsVacant
	   END

---REMOVE DUPLICATES
WITH ROWNumCTE AS(
SELECT * ,
       ROW_NUMBER() OVER (
	   PARTITION BY ParcelID,
	                PropertyAddress,
					SalePrice,
					SaleDate,
					LegalReference
					Order by UniqueID ) row_num

FROM NHouisng)
---Order by ParcelID
SELECT*
FROM ROWNumCTE
where row_num > 1
Order by PropertyAddress

----------------------------------------------------------------------------------------------------------------------

---DELETE UNUSED COLUMN
SELECT *
FROM NHouisng
Order by 2,3

ALTER TABLE NHouisng
DROP COLUMN OwnerAddress,Taxdistrict, PropertyAddress

ALTER TABLE NHouisng
DROP COLUMN SaleDate















