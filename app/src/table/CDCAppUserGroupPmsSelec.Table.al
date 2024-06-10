table 6085633 "CDC App. User Group Pms. Selec"
{
    Caption = 'Approval User Group Permission Selection';
    DataCaptionFields = "Approval User Group Code";

    fields
    {
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
        key(Key1; "Permission Type", Type, "Dimension Code", "Approval User Group Code", "Code / No.")
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