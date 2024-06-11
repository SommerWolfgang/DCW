table 6086351 "CEM Credit Card Mapping"
{
    Caption = 'Credit Card Mapping';
    DataCaptionFields = "Field No.", "Field Name";

    fields
    {
        field(10; "Field No."; Integer)
        {
            Caption = 'Field No.';
        }
        field(20; "Field Name"; Text[30])
        {
            CalcFormula = lookup(Field.FieldName where(TableNo = const(6086330),
                                                        "No." = field("Field No.")));
            Caption = 'Field Name';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Field No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }

    trigger OnDelete()
    begin
        HandleCreditCardUserMapping();
    end;

    trigger OnInsert()
    begin
        HandleCreditCardUserMapping();
    end;

    trigger OnRename()
    begin
        HandleCreditCardUserMapping();
    end;

    var
        CreditCardUserMappingExist: Label 'Mapping data in %1 exist.\\Are you sure you want to delete the mapping data for all the related credit cards? ';


    procedure LookupFieldNo(var Text: Text[1024]): Boolean
    var
        FieldRec: Record "Field";
    begin
        FieldRec.SetRange(TableNo, DATABASE::"CEM Bank Transaction Inbox");
        FieldRec.SetFilter(Type, '%1|%2', FieldRec.Type::Text, FieldRec.Type::Code);
        if FieldRec.Get(DATABASE::"CEM Bank Transaction Inbox", "Field No.") then;

        if PAGE.RunModal(PAGE::"Field List", FieldRec) = ACTION::LookupOK then begin
            Text := Format(FieldRec."No.");
            exit(true);
        end;
    end;

    local procedure HandleCreditCardUserMapping()
    var
        CreditCardUserMapping: Record "CEM Credit Card User Mapping";
    begin
        if not CreditCardUserMapping.FindFirst() then
            exit;

        if Confirm(CreditCardUserMappingExist, false, CreditCardUserMapping.TableCaption) then
            CreditCardUserMapping.DeleteAll();
    end;


    procedure GetListOfAllRequiredFields() RequiredFields: Text[1024]
    var
        CardMapping: Record "CEM Credit Card Mapping";
    begin
        if CardMapping.FindSet() then
            repeat
                CardMapping.CalcFields("Field Name");
                if RequiredFields <> '' then
                    RequiredFields := RequiredFields + ', ';

                RequiredFields := CardMapping."Field Name";
            until CardMapping.Next() = 0;
    end;
}

