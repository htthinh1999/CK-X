/**
 * Question Service
 * Handles question display and navigation
 */

function escapeHtml(text) {
    return text
        .replace(/&/g, '&amp;')
        .replace(/</g, '&lt;')
        .replace(/>/g, '&gt;')
        .replace(/"/g, '&quot;');
}

// Render question text (Markdown) to HTML. Real paragraphs and bullet /
// numbered / nested lists let the spacing rules in exam.css apply, and code
// spans are parsed before emphasis so text like `*/5 * * * *` stays intact.
// Uses the vendored marked parser (/vendor/marked); if it is unavailable,
// falls back to escaped text with line breaks.
function processQuestionContent(content, md = (typeof window !== 'undefined' ? window.marked : undefined)) {
    const text = content || '';
    let html;
    if (md && typeof md.parse === 'function') {
        html = md.parse(text, { gfm: true, breaks: true });
    } else {
        html = escapeHtml(text)
            .replace(/`([^`]+)`/g, '<code>$1</code>')
            .replace(/\n/g, '<br>');
    }
    // Inline code keeps the click-to-copy style; fenced code blocks stay as-is.
    return html
        .split(/(<pre>[\s\S]*?<\/pre>)/)
        .map(part => (part.startsWith('<pre>') ? part : part.replace(/<code>/g, '<code class="inline-code">')))
        .join('');
}

// Generate question content HTML
function generateQuestionContent(question) {
    try {
        // Get original data
        const originalData = question.originalData || {};
        const machineHostname = originalData.machineHostname || 'N/A';
        const namespace = originalData.namespace || 'N/A';
        const concepts = originalData.concepts || [];
        const conceptsString = concepts.join(', ');
        
        // Format question content with improved styling
        const formattedQuestionContent = processQuestionContent(question.content);
        
        // Create formatted content with minimal layout
        return `
            <div class="d-flex flex-column" style="height: 100%;">
                <div class="question-header">
                    
                    <div class="mb-3">
                        <strong>Solve this question on instance:</strong> <span class="inline-code">ssh ${machineHostname}</span></span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Namespace:</strong> <span class="text-primary">${namespace}</span>
                    </div>
                    
                    <div class="mb-3">
                        <strong>Concepts:</strong> <span class="text-primary">${conceptsString}</span>
                    </div>
                    
                    <hr class="my-3">
                </div>
                
                <div class="question-body">
                    ${formattedQuestionContent}
                </div>
                
                <div class="action-buttons-container mt-auto">
                    <div class="d-flex justify-content-between py-2">
                        <button class="btn ${question.flagged ? 'btn-warning' : 'btn-outline-warning'}" id="flagQuestionBtn">
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-flag${question.flagged ? '-fill' : ''} me-2" viewBox="0 0 16 16">
                                <path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12.435 12.435 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A19.626 19.626 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a19.587 19.587 0 0 0 1.349-.476l.019-.007.004-.002h.001"/>
                            </svg>
                            ${question.flagged ? 'Flagged' : 'Flag for review'}
                        </button>
                        <button class="btn btn-success" id="nextQuestionBtn">
                            Satisfied with answer
                            <svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" class="bi bi-arrow-right ms-2" viewBox="0 0 16 16">
                                <path fill-rule="evenodd" d="M1 8a.5.5 0 0 1 .5-.5h11.793l-3.147-3.146a.5.5 0 0 1 .708-.708l4 4a.5.5 0 0 1 0 .708l-4 4a.5.5 0 0 1-.708-.708L13.293 8.5H1.5A.5.5 0 0 1 1 8z"/>
                            </svg>
                        </button>
                    </div>
                </div>
            </div>
        `;
    } catch (error) {
        console.error('Error generating question content:', error);
        return '<div class="alert alert-danger">Error displaying question content. Please try refreshing the page.</div>';
    }
}

// Transform API response to question objects
function transformQuestionsFromApi(data) {
    if (data.questions && Array.isArray(data.questions)) {
        // Transform the questions to match our expected format
        return data.questions.map(q => ({
            id: q.id,
            content: q.question || '', // Map 'question' field to 'content'
            title: `Question ${q.id}`,  // Create a title from the ID
            originalData: q, // Keep original data for reference if needed
            flagged: false // Add flagged status property
        }));
    }
    return [];
}

// Update question dropdown
function updateQuestionDropdown(questionsArray, dropdownMenu, currentId, onQuestionSelect) {
    // Clear existing dropdown items
    dropdownMenu.innerHTML = '';
    
    // Add items for each question
    questionsArray.forEach((question) => {
        const li = document.createElement('li');
        const a = document.createElement('a');
        a.className = 'dropdown-item';
        a.href = '#';
        a.dataset.question = question.id;
        a.textContent = `Question ${question.id}`;
        
        // Add flag icon if question is flagged
        if (question.flagged) {
            const flagIcon = document.createElement('span');
            flagIcon.className = 'flag-icon ms-2';
            flagIcon.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="12" height="12" fill="currentColor" class="bi bi-flag-fill text-warning" viewBox="0 0 16 16"><path d="M14.778.085A.5.5 0 0 1 15 .5V8a.5.5 0 0 1-.314.464L14.5 8l.186.464-.003.001-.006.003-.023.009a12.435 12.435 0 0 1-.397.15c-.264.095-.631.223-1.047.35-.816.252-1.879.523-2.71.523-.847 0-1.548-.28-2.158-.525l-.028-.01C7.68 8.71 7.14 8.5 6.5 8.5c-.7 0-1.638.23-2.437.477A19.626 19.626 0 0 0 3 9.342V15.5a.5.5 0 0 1-1 0V.5a.5.5 0 0 1 1 0v.282c.226-.079.496-.17.79-.26C4.606.272 5.67 0 6.5 0c.84 0 1.524.277 2.121.519l.043.018C9.286.788 9.828 1 10.5 1c.7 0 1.638-.23 2.437-.477a19.587 19.587 0 0 0 1.349-.476l.019-.007.004-.002h.001"/></svg>';
            a.appendChild(flagIcon);
        }
        
        // Add click event
        a.addEventListener('click', function(e) {
            e.preventDefault();
            const clickedQuestionId = this.dataset.question;
            if (onQuestionSelect) {
                onQuestionSelect(clickedQuestionId);
            }
        });
        
        li.appendChild(a);
        dropdownMenu.appendChild(li);
    });
}

export {
    processQuestionContent,
    generateQuestionContent,
    transformQuestionsFromApi,
    updateQuestionDropdown
}; 