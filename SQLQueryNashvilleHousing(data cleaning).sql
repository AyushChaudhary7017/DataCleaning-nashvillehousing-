/*
Cleaning data in sql queries
*/
select*
from PortfolioProject..NashvilleHousing

-- Standardize date format
select SaleDateConverted,convert(date,SaleDate)
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

-- If it doesn't Update properly

alter table NashvilleHousing
add SaleDateConverted date;

update NashvilleHousing 
set SaleDateConverted = convert(date,SaleDate)

-- Populate Property Address data
select*
from PortfolioProject..NashvilleHousing
--where PropertyAddress is null
order by ParcelID

select A.ParcelID ,A.PropertyAddress,B.ParcelID,B.PropertyAddress, isnull(A.PropertyAddress , B.PropertyAddress )
from PortfolioProject..NashvilleHousing A
join PortfolioProject..NashvilleHousing B
on A.ParcelID = B.ParcelID
and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress IS NULL

update A
set PropertyAddress = isnull(A.PropertyAddress , B.PropertyAddress )
from PortfolioProject..NashvilleHousing A
join PortfolioProject..NashvilleHousing B
on A.ParcelID = B.ParcelID
and A.[UniqueID] <> B.[UniqueID]
where A.PropertyAddress IS NULL

-- Breaking out Address into Individual Columns (Address, City, State)
select PropertyAddress
from PortfolioProject..NashvilleHousing
--where PropertyAddress IS NULL
--order by ParcelID

select SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as address,
SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as address
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add propertysplitadress nvarchar(255);

update NashvilleHousing
set propertysplitadress = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

alter table NashvilleHousing
add propertysplitcity nvarchar(255);

update NashvilleHousing
set propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

select OwnerAddress
from PortfolioProject..NashvilleHousing

select parsename(replace( OwnerAddress,',', '.'),1),
parsename(replace( OwnerAddress,',', '.'),2),
parsename(replace( OwnerAddress,',', '.'),3)
from PortfolioProject..NashvilleHousing

alter table NashvilleHousing
add ownersplitaddress nvarchar(255);

update NashvilleHousing
set ownersplitaddress = parsename(replace( OwnerAddress,',', '.'),3)

alter table NashvilleHousing
add ownersplitcity nvarchar(255);

update NashvilleHousing
set ownersplitcity = parsename(replace( OwnerAddress,',', '.'),2)

alter table NashvilleHousing
add ownersplitstate nvarchar(255);

update NashvilleHousing
set ownersplitstate = parsename(replace( OwnerAddress,',', '.'),1)

select*
from PortfolioProject..NashvilleHousing

-- Change Y and N to Yes and No in "Sold as Vacant" field

select distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject..NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant,
case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end
from PortfolioProject..NashvilleHousing

update NashvilleHousing
set SoldAsVacant = case 
when SoldAsVacant = 'Y' then 'Yes'
when SoldAsVacant = 'N' then 'No'
else SoldAsVacant
end

select*
from PortfolioProject..NashvilleHousing

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From PortfolioProject.dbo.NashvilleHousing
--order by ParcelID
)
Select*
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



			 --delete from RowNumCTE
			 --where row_num>1
			 --order by PropertyAddress

select *
from PortfolioProject..NashvilleHousing

-- delete unused columns

select*
from PortfolioProject..NashvilleHousing

alter table PortfolioProject..NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table PortfolioProject..NashvilleHousing
drop column SaleDate,SoldAsVacant

