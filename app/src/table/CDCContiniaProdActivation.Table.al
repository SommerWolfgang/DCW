table 6192772 "CDC Continia Prod. Activation"
{
    Caption = 'Continia Product Activation';
    DataPerCompany = false;

    fields
    {
        field(1; "Product Code"; Code[10])
        {
            Caption = 'Product Code';
        }
        field(2; "Company Name"; Text[30])
        {
            Caption = 'Company Name';
        }
        field(3; "Hashed System Identifier"; Text[128])
        {
            Caption = 'Hashed System Identifier';
        }
        field(4; "Activation Date"; Date)
        {
            Caption = 'Activation Date';
        }
        field(5; "Activated by User ID"; Code[50])
        {
            Caption = 'Activated by User ID';
            DataClassification = EndUserIdentifiableInformation;
        }
        field(6; "Expiration Date"; Date)
        {
            Caption = 'Expiration Date';
        }
        field(7; "Database Name"; Text[128])
        {
            Caption = 'Database Name';
        }
        field(8; "Database Creator"; Text[64])
        {
            Caption = 'Database Created by';
        }
        field(9; "Database Created"; Date)
        {
            Caption = 'Database Created Date';
        }
        field(10; "Product Version"; Text[30])
        {
            Caption = 'Product Version';
        }
        field(11; "Company GUID"; Guid)
        {
            Caption = 'Company GUID';
        }
        field(12; "Client ID"; Code[20])
        {
            Caption = 'Client ID';
            CharAllowed = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ+-';
            NotBlank = true;
        }
        field(13; "Company Code"; Code[10])
        {
            Caption = 'Company Code';
            CharAllowed = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ+-';
        }
        field(20; "Offline Activation Status"; Option)
        {
            Caption = 'Offline Activation Status';
            OptionCaption = ' ,Started,Active';
            OptionMembers = " ",Started,Active;
        }
    }

    keys
    {
        key(Key1; "Product Code", "Company Name")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }
}

