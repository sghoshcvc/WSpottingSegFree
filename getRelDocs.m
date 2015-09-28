function relDoc = getRelDocs(data)

nClasses = length(data.idxClasses);
nDocs = length(data.docClasses);
relDoc = cell(nClasses,nDocs);
%relDoc={};
nWords = length(data.words);
for i=1:nWords
    cIndex = data.words(i).class;
    docIndex = data.words(i).docIdx;
    %if (relDoc{cIndex,docIndex})
     %   relDoc{cIndex,docIndex) = [i];
    %else
        relDoc{cIndex,docIndex} = [relDoc{cIndex,docIndex} i];
   % end
end
end

