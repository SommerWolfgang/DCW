table 6085743 "CDC Approval Group"
{
    Caption = 'Approval Groups';

    fields
    {
        field(1; "Code"; Code[10])
        {
            Caption = 'Code';
            NotBlank = true;
        }
        field(2; Priority; Integer)
        {
            Caption = 'Priority';
        }
        field(5; Description; Text[50])
        {
            Caption = 'Description';
        }
        field(9; "Four Eyes Approval"; Option)
        {
            Caption = 'Four Eyes Approval';
            OptionCaption = ' ,Invoice,Invoice Full Amount';
            OptionMembers = " ",Invoice,"Invoice Full Amount";
        }
        field(12; "First Entry Created by"; Option)
        {
            Caption = 'First Entry Created by';
            DataClassification = EndUserIdentifiableInformation;
            InitValue = "Approver ID";
            OptionCaption = ' ,Approver ID,Purchaser';
            OptionMembers = " ","Approver ID",Purchaser;
        }
        field(100; "Purchase Header Filter"; TableFilter)
        {
            Caption = 'Purchase Header Filter';
        }
        field(101; "Purchaser Filter"; TableFilter)
        {
            Caption = 'Purchaser Filter';
        }
        field(102; "Vendor Filter"; TableFilter)
        {
            Caption = 'Vendor Filter';
        }
    }

    keys
    {
        key(Key1; "Code")
        {
            Clustered = true;
        }
        key(Key2; Priority)
        {
        }
    }
    procedure SetPriority(var AppvlGroup: Record "CDC Approval Group")
    begin
    end;
}