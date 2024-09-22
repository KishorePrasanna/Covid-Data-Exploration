Select * 
From NashvilleHousing	

-- Standardize Date Format

Select SaleDate, Convert(Date,Saledate) as Date
From NashvilleHousing	

Update NashvilleHousing 
Set SaleDate = Convert(Date,Saledate)

Alter Table NashvilleHousing
Add SaleConverted Date;

Update NashvilleHousing 
Set SaleConverted = Convert(Date,Saledate)

-----------------------------------------------------------------------------------------------------

--Populate Property address Data

Select * 
From NashvilleHousing
-- Where PropertyAddress is null
Order By ParcelID

Select A.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, 
ISNULL(a.PropertyAddress,b.PropertyAddress) 
From NashvilleHousing as a
Join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where A.PropertyAddress is null

Update a
Set PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From NashvilleHousing as a
Join NashvilleHousing as b
	on a.ParcelID = b.ParcelID
	And a.[UniqueID ]<> b.[UniqueID ]
Where A.PropertyAddress is null

------------------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individuall Columns (Address,City,State)

Select PropertyAddress
From NashvilleHousing
-- Where PropertyAddress is null
--Order By PropertyAddress

Select 
Substring(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) as Address,
Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
From NashvilleHousing


Alter Table NashvilleHousing
Add PropertySplitAddress NVARCHAR(255);

Update NashvilleHousing 
Set PropertySplitAddress = Substring(PropertyAddress, 1,CHARINDEX(',',PropertyAddress)-1)

Alter Table NashvilleHousing
Add PropertySplitCity NVARCHAR(255);

Update NashvilleHousing 
Set PropertySplitCity = Substring(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

Select PropertySplitAddress, PropertySplitCity
From NashvilleHousing

-------------------------------------------------------------------------------------------------------
--Owener Address

Select ownerAddress
From NashvilleHousing

Select PARSENAME(REPLACE(ownerAddress,',','.'),3) as OwnerSplitAddress,
	PARSENAME(REPLACE(ownerAddress,',','.'),2) as OwnerSplitCity,
	PARSENAME(REPLACE(ownerAddress,',','.'),1) as OwnerSplitState
From NashvilleHousing

Alter Table NashvilleHousing
Add OwnerSplitCity NVARCHAR(255);

Update NashvilleHousing 
Set OwnerSplitCity = PARSENAME(REPLACE(ownerAddress,',','.'),2)

Alter Table NashvilleHousing
Add OwnerSplitAddress NVARCHAR(255);

Update NashvilleHousing 
Set OwnerSplitAddress = PARSENAME(REPLACE(ownerAddress,',','.'),3)

Alter Table NashvilleHousing
Add OwnerSplitState NVARCHAR(255);

Update NashvilleHousing 
Set OwnerSplitState = PARSENAME(REPLACE(ownerAddress,',','.'),1)

------------------------------------------------------------------------------------------------------------

-- Select Y and N to Yes and NO in select and vacent field

Select Distinct(SoldasVacant), Count(SoldasVacant)
From NashvilleHousing
Group by SoldasVacant
Order By 2

Select , 
Case When Soldasvacant = 'Y' then 'YES'
	When Soldasvacant = 'Yes' then 'YES'
	When SoldasvaSoldasVacantcant = 'N' then 'NO'
	When Soldasvacant = 'No' then 'NO'
	Else Soldasvacant
	END
From NashvilleHousing

UPDATE NashvilleHousing
set Soldasvacant = Case 
	When Soldasvacant = 'Y' then 'YES'
	When Soldasvacant = 'Yes' then 'YES'
	When Soldasvacant = 'N' then 'NO'
	When Soldasvacant = 'No' then 'NO'
	Else Soldasvacant
	END
From NashvilleHousing

---------------------------------------------------------------------------------------------
--Removing Duplicates

With RowNOCTE as(
Select * , 
	ROW_NUMBER() 
		over (Partition by 
			ParcelID, 
			PropertyAddress, 
			SalePrice, 
			Saledate,
			LegalReference 
			Order by uniqueID
	) as RowNum
From NashvilleHousing)
--Order By ParcelID

Select *  -- select to Delete to delete the dupelicates 
From RowNOCTE
Where RowNum > 1
Order By PropertyAddress

Select * From NashvilleHousing

-----------------------------------------------------------------------------------------------------
-- Deleting Unused Column

Select * From NashvilleHousing

Alter Table NashvilleHousing
Drop Column OwnerAddress, TaxDistrict, propertyAddress, saleDate


