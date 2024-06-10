table 6086333 "CEM Exp. Posting Desc. Field"
{
    Caption = 'Posting Desc. Field';
    DataCaptionFields = "Field Type Code", "Field Description";

    fields
    {
        field(1; "Parameter No."; Integer)
        {
            Caption = 'Parameter No.';
        }
        field(10; "Field Type Code"; Code[20])
        {
            Caption = 'Field Type Code';
            TableRelation = "CEM Field Type";
        }
        field(11; "Field Description"; Text[50])
        {
            CalcFormula = Lookup("CEM Field Type".Description WHERE(Code = FIELD("Field Type Code")));
            Caption = 'Field Description';
            Editable = false;
            FieldClass = FlowField;
        }
    }

    keys
    {
        key(Key1; "Parameter No.")
        {
            Clustered = true;
        }
    }

    fieldgroups
    {
    }


    procedure GetPostingDesc(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer): Text[1024]
    var
        EMSetup: Record "CEM Expense Management Setup";
        DescriptionTxt: Text[30];
    begin
        EMSetup.Get;
        case TableID of
            DATABASE::"CEM Expense", DATABASE::"CEM Expense Allocation":
                DescriptionTxt := EMSetup."Posting Description";
            DATABASE::"CEM Mileage":
                DescriptionTxt := EMSetup."Mileage Posting Description";
            DATABASE::"CEM Expense Header":
                DescriptionTxt := EMSetup."Settlement Posting Description";
            DATABASE::"CEM Per Diem":
                DescriptionTxt := EMSetup."Per Diem Posting Description";
        end;

        exit(ReplacePlaceholdersWithValues(TableID, DocumentType, DocumentNo, DocRefNo, DescriptionTxt));
    end;


    procedure GetInvPostingDesc(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer): Text[1024]
    var
        EMSetup: Record "CEM Expense Management Setup";
    begin
        EMSetup.Get;
        exit(ReplacePlaceholdersWithValues(TableID, DocumentType, DocumentNo, DocRefNo, EMSetup."Invoice Posting Description"));
    end;

    local procedure ReplacePlaceholdersWithValues(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; InputDescription: Text[1024]) PostingDesc: Text[1024]
    var
        ExpPostingDescFields: Record "CEM Exp. Posting Desc. Field";
    begin
        PostingDesc := InputDescription;

        ExpPostingDescFields.Ascending(false);
        if ExpPostingDescFields.FindFirst then
            repeat
                PostingDesc :=
                  ReplaceText(PostingDesc, '%' + Format(ExpPostingDescFields."Parameter No."),
                    GetFieldValue(TableID, DocumentType, DocumentNo, DocRefNo, ExpPostingDescFields."Field Type Code"), false);
            until ExpPostingDescFields.Next = 0;
    end;

    local procedure ReplaceText(Text: Text[1024]; ReplaceTxt: Text[1024]; ReplaceWithTxt: Text[1024]; CaseSensitive: Boolean): Text[1024]
    var
        i: Integer;
        ReplaceTxtLen: Integer;
        ReplaceWithTxtLen: Integer;
    begin
        ReplaceTxtLen := StrLen(ReplaceTxt);
        ReplaceWithTxtLen := StrLen(ReplaceWithTxt);

        if CaseSensitive then
            i := StrPos(Text, ReplaceTxt)
        else
            i := StrPos(UpperCase(Text), UpperCase(ReplaceTxt));

        if i <> 0 then begin
            Text := CopyStr(Text, 1, i - 1) + ReplaceWithTxt + CopyStr(Text, i + ReplaceTxtLen);
            Text :=
              CopyStr(Text, 1, i - 1 + ReplaceWithTxtLen) +
                ReplaceText(CopyStr(Text, i + ReplaceWithTxtLen), ReplaceTxt, ReplaceWithTxt, CaseSensitive);
        end;

        exit(Text);
    end;

    local procedure GetFieldValue(TableID: Integer; DocumentType: Integer; DocumentNo: Code[20]; DocRefNo: Integer; FieldTypeCode: Code[20]): Text[1024]
    var
        EMDim: Record "CEM Dimension";
        Expense: Record "CEM Expense";
        ExpAllocation: Record "CEM Expense Allocation";
        EMAllocDim: Record "CEM Expense Allocation Dim.";
        ExpHeader: Record "CEM Expense Header";
        FieldType: Record "CEM Field Type";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        PerDiemDetail: Record "CEM Per Diem Detail";
        FieldTypeCodeMgt: Codeunit "CEM Field Type Code Mgt.";
        RecRef: RecordRef;
        FldRef: FieldRef;
        DimCode: Code[20];
        FldNo: Integer;
    begin
        if FieldType.Get(FieldTypeCode) then
            if FieldType.IsSystemFieldForTable(TableID) then begin
                case TableID of
                    DATABASE::"CEM Expense":
                        begin
                            Expense.Get(DocRefNo);
                            RecRef.GetTable(Expense);
                            FldRef := RecRef.Field(FieldTypeCodeMgt.GetExpSystemFieldNo(FieldType.Code));
                        end;

                    DATABASE::"CEM Expense Allocation":
                        begin
                            ExpAllocation.Get(DocRefNo);
                            RecRef.GetTable(ExpAllocation);
                            if FieldTypeCodeMgt.GetExpAllocSystemFieldNo(FieldType.Code) > 0 then
                                FldRef := RecRef.Field(FieldTypeCodeMgt.GetExpAllocSystemFieldNo(FieldType.Code))
                            else begin
                                // Take the field value from the expense, the allocation doesn't have it.
                                Expense.Get(ExpAllocation."Expense Entry No.");
                                RecRef.GetTable(Expense);
                                FldRef := RecRef.Field(FieldTypeCodeMgt.GetExpSystemFieldNo(FieldType.Code));
                            end;
                        end;

                    DATABASE::"CEM Mileage":
                        begin
                            Mileage.Get(DocRefNo);
                            RecRef.GetTable(Mileage);
                            FldRef := RecRef.Field(FieldTypeCodeMgt.GetMilSystemFieldNo(FieldType.Code));
                        end;

                    DATABASE::"CEM Expense Header":
                        begin
                            ExpHeader.Get(DocumentType, DocumentNo);
                            RecRef.GetTable(ExpHeader);
                            FldRef := RecRef.Field(FieldTypeCodeMgt.GetSettlementSystemFieldNo(FieldType.Code));
                        end;

                    DATABASE::"CEM Per Diem":
                        begin
                            PerDiem.Get(DocRefNo);
                            RecRef.GetTable(PerDiem);
                            FldRef := RecRef.Field(FieldTypeCodeMgt.GetPerDiemSystemFieldNo(FieldType.Code));
                        end;
                end;

                if Format(FldRef.Class) = 'FlowField' then
                    FldRef.CalcField;

                exit(PostProcessString(TableID, FldRef.Number, Format(FldRef.Value)));

            end else begin
                case TableID of
                    DATABASE::"CEM Expense", DATABASE::"CEM Mileage", DATABASE::"CEM Expense Header", DATABASE::"CEM Per Diem":
                        begin
                            DimCode := FieldType.GetDimCode;

                            EMDim.SetCurrentKey("Table ID", "Document Type", "Document No.", "Doc. Ref. No.");
                            EMDim.SetRange("Table ID", TableID);
                            EMDim.SetRange("Document Type", DocumentType);
                            EMDim.SetRange("Document No.", DocumentNo);
                            EMDim.SetRange("Doc. Ref. No.", DocRefNo);

                            if DimCode <> '' then begin
                                EMDim.SetRange("Dimension Code", DimCode);
                                if EMDim.FindFirst then
                                    exit(EMDim."Dimension Value Code");
                            end else begin
                                EMDim.SetRange("Field Code", FieldTypeCode);
                                if EMDim.FindFirst then
                                    exit(EMDim."Field Value");
                            end;
                        end;

                    DATABASE::"CEM Expense Allocation":
                        begin
                            DimCode := FieldType.GetDimCode;

                            EMAllocDim.SetRange("Expense Allocation Entry No.", DocRefNo);
                            if DimCode <> '' then begin
                                EMAllocDim.SetRange("Dimension Code", DimCode);
                                if EMAllocDim.FindFirst then
                                    exit(EMAllocDim."Dimension Value Code");
                            end else begin
                                EMAllocDim.SetRange("Field Code", FieldTypeCode);
                                if EMAllocDim.FindFirst then
                                    exit(EMAllocDim."Field Value");
                            end;
                        end;
                end;
            end;
    end;


    procedure PostProcessString(TableID: Integer; FieldID: Integer; String: Text[1024]): Text[1024]
    var
        Expense: Record "CEM Expense";
        ExpHeader: Record "CEM Expense Header";
        Mileage: Record "CEM Mileage";
        PerDiem: Record "CEM Per Diem";
        ContUserMgt: Codeunit "CDC Continia User Mgt.";
    begin
        if FieldID <= 0 then
            exit;

        case TableID of
            DATABASE::"CEM Expense", DATABASE::"CEM Expense Allocation":
                case FieldID of
                    Expense.FieldNo("Continia User ID"):
                        exit(ContUserMgt.RemoveDomainName(String));
                end;
            DATABASE::"CEM Mileage":
                case FieldID of
                    Mileage.FieldNo("Continia User ID"):
                        exit(ContUserMgt.RemoveDomainName(String));
                end;
            DATABASE::"CEM Expense Header":
                case FieldID of
                    ExpHeader.FieldNo("Continia User ID"):
                        exit(ContUserMgt.RemoveDomainName(String));
                end;
            DATABASE::"CEM Per Diem":
                case FieldID of
                    PerDiem.FieldNo("Continia User ID"):
                        exit(ContUserMgt.RemoveDomainName(String));
                end;
        end;

        exit(String);
    end;
}

