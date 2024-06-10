table 6085635 "CDC Continia User Pms. Sel."
{
    Caption = 'Continia User Permission Selection';
    DataCaptionFields = "Continia User ID", "Approval User Group Code";

    fields
    {
        field(1; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            DataClassification = EndUserIdentifiableInformation;
            NotBlank = true;
            TableRelation = "CDC Continia User Setup";
        }
        field(2; "Approval User Group Code"; Code[20])
        {
            Caption = 'Approval User Group Code';
            TableRelation = "CDC Approval User Group";
        }
        field(3; Type; Option)
        {
            Caption = 'Type';
            OptionCaption = 'G/L Account,Item,,Fixed Asset,Charge (Item),Dimension,Job';
            OptionMembers = "G/L Account",Item,Resource,"Fixed Asset","Charge (Item)",Dimension,Job;
        }
        field(4; "Dimension Code"; Code[20])
        {
            Caption = 'Dimension Code';
            TableRelation = Dimension;
        }
        field(6; "Code / No."; Code[20])
        {
            Caption = 'Code / No.';
        }
        field(7; "Permission Type"; Option)
        {
            Caption = 'Permission Type';
            OptionCaption = 'Assigning Permission,Approval Permission';
            OptionMembers = "Assigning Permission","Approval Permission";
        }
    }

    keys
    {
        key(Key1; "Permission Type", "Continia User ID", Type, "Dimension Code", "Approval User Group Code", "Code / No.")
        {
            Clustered = true;
        }
    }
    procedure SetCurrCompanyNameTbl(NewCompanyName: Text[30])
    begin
    end;

    procedure GetCurrCompanyNameTbl(): Text[30]
    begin
    end;
}