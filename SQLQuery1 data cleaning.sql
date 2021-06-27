Select *
From PortfolioProject.dbo.NashvilleHousing


----------------------------------------------------
--Standardize Date format

Select SaleDate, CONVERT(Date, SaleDate)
From PortfolioProject.dbo.NashvilleHousing


--Add Column SaleDateConverted
ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add SaleDateConverted Date;

-- Update the NashvilleHousing Table
Update PortfolioProject.dbo.NashvilleHousing
SET SaleDateConverted = CONVERT(Date,SaleDate) 


-------------------------------------------------------
--Populate Property Address Data

Select *
From PortfolioProject.dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


-- Self joining the Nashville table to populate the PropertyAddress
Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.NashvilleHousing a
JOIN PortfolioProject.dbo.NashvilleHousing b
	ON a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.PropertyAddress is null


----------------------------------------------------------------------------
--Breaking out PropertyAddress into individual columns (address, city)


Select PropertyAddress
From PortfolioProject.dbo.NashvilleHousing


SELECT
SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address
, SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))
FROM PortfolioProject.dbo.NashvilleHousing


ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitAddress Nvarchar(255) ;

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitAddress =SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add PropertySplitCity Nvarchar(255);

Update PortfolioProject.dbo.NashvilleHousing
SET PropertySplitCity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1, LEN (PropertyAddress))


select *
from PortfolioProject.dbo.NashvilleHousing


---------------------------------------------------------------------
--Splitting the owneraddress into address, city and state
select 
PARSENAME(REPLACE(OwnerAddress,',','.'),3)
,PARSENAME(REPLACE(OwnerAddress,',','.'),2)
,PARSENAME(REPLACE(OwnerAddress,',','.'),1)
from PortfolioProject.dbo.NashvilleHousing



 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitAddress Nvarchar(255) ;

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress,',','.'),3)


 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitCity Nvarchar(255) ;

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.'),2)


 ALTER TABLE PortfolioProject.dbo.NashvilleHousing
Add OwnerSplitStates Nvarchar(255) ;

Update PortfolioProject.dbo.NashvilleHousing
SET OwnerSplitStates =PARSENAME(REPLACE(OwnerAddress,',','.'),1)


select * 
from PortfolioProject.dbo.NashvilleHousing


-------------------------------------------------------------------------

--showing unique values in a SoldAsVacant column
select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.dbo.NashvilleHousing
group by SoldAsVacant
order by 2


--changing  Y and N to Yes and No in 'Sold as Vacant' field using case statement

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELse SoldAsVacant
	 END
from PortfolioProject.dbo.NashvilleHousing


update PortfolioProject.dbo.NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' THEN 'Yes'
	 when SoldAsVacant = 'N' THEN 'No'
	 ELse SoldAsVacant
	 END
------------------------------------------------------------------------

--Deleting  Unused columns

Select *
from PortfolioProject.dbo.NashvilleHousing


Alter Table PortfolioProject.dbo.NashvilleHousing
Drop column OwnerAddress, TaxDistrict, PropertyAddress, SaleDate

